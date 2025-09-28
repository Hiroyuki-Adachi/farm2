import "bootstrap";
import Decimal from "decimal.js";

export const init = () => {
  const kamokuForm = new bootstrap.Modal(document.getElementById("kamoku_modal"));
  const totalForm = new bootstrap.Modal(document.getElementById("total_modal"));

  const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
      if (meta.getAttribute('name') === 'csrf-token') {
        return meta.getAttribute('content');
      }
    }
    return '';
  };

  const addEventEditWorkTypes = (element) => {
    element.addEventListener("click", () => {
      fetch(element.dataset.url)
      .then((res) => {
        if (res.ok) {
          return res.text();
        }
      })
      .then((data) => {
        const kamokuBody = document.getElementById("kamoku_body");
        kamokuBody.innerHTML = data;
        kamokuBody.querySelectorAll(".sorimachi-work-type").forEach((element) => {
          element.addEventListener("change", () => {
            const sorimachiAmount = document.getElementById(`sorimachi_amount_${element.dataset.work}`);
            if (!element.checked) {
              sorimachiAmount.value = 0;
            }
            sorimachiAmount.disabled = !element.checked;
            resetAmounts();
          });
        });
        kamokuForm.show();
      });
    });
  };

  const addEventUpdateFlag = (element) => {
    element.addEventListener("click", () => {
      fetch(element.dataset.url, {
        method: "PUT",
        headers: {
          'X-CSRF-Token': getCsrfToken()
        }
      })
      .then((res) => {
        if (res.ok) {
          return res.text();
        }
      })
      .then((data) => {
        const journalTr = document.getElementById(`tr_${element.dataset.id}`);
        journalTr.innerHTML = data;
        journalTr.querySelectorAll("button.edit-work-types").forEach((element) => {
          addEventEditWorkTypes(element);
        });
        journalTr.querySelectorAll("button.copy").forEach((element) => {
          addEventCopy(element);
        });
      });
    });
  };

  const addEventCopy = (element) => {
    element.addEventListener("click", () => {
      fetch(element.dataset.url, {
        method: "POST",
        headers: {
          'X-CSRF-Token': getCsrfToken()
        }
      })
      .then((res) => {
        if (res.ok) {
          return res.text();
        }
      })
      .then((data) => {
        const journalTr = document.getElementById(`tr_${element.dataset.id}`);
        journalTr.innerHTML = data;
        journalTr.querySelectorAll("button.edit-work-types").forEach((element) => {
          addEventEditWorkTypes(element);
        });
        journalTr.querySelectorAll("button.copy").forEach((element) => {
          addEventCopy(element);
        });
      });
    });
  };

  const resetAmounts = () => {
    let sumArea = new Decimal(0);
    let maxArea = 0.0;
    let maxWorkType = "";
    const amount = new Decimal(document.getElementById("sorimachi_cost_amount").value);

    document.querySelectorAll(".sorimachi-work-type:checked").forEach((element) => {
      sumArea = sumArea.plus(new Decimal(element.dataset.area));
      if (maxArea <= parseFloat(element.dataset.area)) {
        maxArea = parseFloat(element.dataset.area);
        maxWorkType = element.dataset.work;
      }
    });
    let calcSumAmount = new Decimal(0);
    if (sumArea.eq(0)) {
      document.getElementById("sorimachi_total").innerText = 0;
    } else {
      document.querySelectorAll(".sorimachi-work-type:checked").forEach((element) => {
        const area = new Decimal(element.dataset.area);
        document.getElementById(`sorimachi_amount_${element.dataset.work}`).value = amount.mul(area).div(sumArea).round();
        calcSumAmount = calcSumAmount.plus(amount.mul(area).div(sumArea).round());
      });
      document.getElementById("sorimachi_total").innerText = calcSumAmount.toNumber().toLocaleString();
    }
    if(!calcSumAmount.eq(amount)) {
      const maxAmount = document.getElementById(`sorimachi_amount_${maxWorkType}`);
      maxAmount.value = new Decimal(maxAmount.value).plus(amount).minus(calcSumAmount);
    }
  };

  document.querySelectorAll("button.has-details").forEach((element) => {
    element.addEventListener("click", () => {
      const dispFlag = (element.dataset.details != "true");
      element.dataset.details = dispFlag.toString();
      document.querySelectorAll(`[data-detail-line="${element.dataset.line}"]`).forEach((detail) => {
        detail.style.display = dispFlag ? "table-row" : "none";
      });
    });
  });
  
  document.querySelectorAll("button.edit-work-types").forEach((element) => {
    addEventEditWorkTypes(element);
  });

  document.querySelectorAll("button.update-flag").forEach((element) => {
    addEventUpdateFlag(element);
  });

  document.querySelectorAll("button.copy").forEach((element) => {
    addEventCopy(element);
  });

  document.getElementById("kamoku_close").addEventListener("click", () => {
    kamokuForm.hide();
  });

  document.getElementById("total_close").addEventListener("click", () => {
    totalForm.hide();
  });

  document.getElementById("kamoku_reset").addEventListener("click", () => {
    resetAmounts();
  });

  document.getElementById("kamoku_update").addEventListener("click", () => {
    const form = document.getElementById("sorimachi_form");
    const journalId = form.dataset.id;
    fetch(form.action, {
      method: "PUT",
      headers: {
        'X-CSRF-Token': getCsrfToken()
      },
      body: new FormData(form)
    })
    .then((res) => {
      if (res.ok) {
        return res.text();
      }
    })
    .then((data) => {
      const journalTr = document.getElementById(`tr_${journalId}`);
      journalTr.innerHTML = data;
      journalTr.querySelectorAll("button.edit-work-types").forEach((element) => {
        addEventEditWorkTypes(element);
      });
      kamokuForm.hide();
    });
  });

  document.getElementById("kamoku_delete").addEventListener("click", (event) => {
    const journalId = document.getElementById("sorimachi_id").value;
    fetch(event.target.dataset.url.replace("@", journalId), {
      method: "DELETE",
      headers: {
        'X-CSRF-Token': getCsrfToken()
      }
    })
    .then((res) => {
      if (res.ok) {
        return res.text();
      }
    })
    .then((data) => {
      const journalTr = document.getElementById(`tr_${journalId}`);
      journalTr.innerHTML = data;
      journalTr.querySelectorAll("button.update-flag").forEach((element) => {
        addEventUpdateFlag(element);
      });
      kamokuForm.hide();
    });
  });

  document.getElementById("total_button").addEventListener("click", (event) => {
    fetch(event.target.dataset.url)
    .then((res) => {
      if (res.ok) {
        return res.text();
      }
    })
    .then((data) => {
      document.getElementById("total_body").innerHTML = data;
      totalForm.show();
    })
  })
};
