import { Modal } from "bootstrap";
import Decimal from "decimal.js";

window.addEventListener("load", () => {
  const popupForm = new Modal(document.getElementById("kamoku_modal"));

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
      .then((response) => {
        return response.text();
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
        popupForm.show();
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
      .then((response) => {
        return response.text();
      })
      .then((data) => {
        const journalTr = document.getElementById(`tr_${element.dataset.id}`);
        journalTr.innerHTML = data;
        journalTr.querySelectorAll("button.edit-work-types").forEach((element) => {
          addEventEditWorkTypes(element);
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
      if (maxArea < parseFloat(element.dataset.area)) {
        maxArea = parseFloat(element.dataset.area);
        maxWorkType = element.dataset.work;
      }
    });
    if (!sumArea.eq(0)) {
      let calcSumAmount = new Decimal(0);
      document.querySelectorAll(".sorimachi-work-type:checked").forEach((element) => {
        const area = new Decimal(element.dataset.area);
        document.getElementById(`sorimachi_amount_${element.dataset.work}`).value = amount.mul(area).div(sumArea).round();
        calcSumAmount = calcSumAmount.plus(amount.mul(area).div(sumArea).round());
      });

      if(!calcSumAmount.eq(amount)) {
        const maxAmount = document.getElementById(`sorimachi_amount_${maxWorkType}`);
        maxAmount.value = new Decimal(maxAmount.value).plus(amount).minus(calcSumAmount);
      }
    }
  };

  document.querySelectorAll("button.has-details").forEach((element) => {
    element.addEventListener("click", (event) => {
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

  document.getElementById("kamoku_close").addEventListener("click", () => {
    popupForm.hide();
  });

  document.getElementById("kamoku_reset").addEventListener("click", () => {
    resetAmounts();
  });

  document.getElementById("kamoku_delete").addEventListener("click", (event) => {
    const journalId = document.getElementById("sorimachi_id").value;
    fetch(event.target.dataset.url.replace("@", journalId), {
      method: "DELETE",
      headers: {
        'X-CSRF-Token': getCsrfToken()
      }
    })
    .then((response) => {
      return response.text();
    })
    .then((data) => {
      const journalTr = document.getElementById(`tr_${journalId}`);
      journalTr.innerHTML = data;
      journalTr.querySelectorAll("button.update-flag").forEach((element) => {
        addEventUpdateFlag(element);
      });
      popupForm.hide();
    });
  });
});
