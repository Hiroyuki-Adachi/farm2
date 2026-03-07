import "bootstrap";

export const init = () => {
  const csrfToken = () => {
    const meta = document.querySelector("meta[name='csrf-token']");
    return meta ? meta.getAttribute("content") : "";
  };

  const submitAllocation = (changed) => {
    const rowId = changed.dataset.rowId;
    const journalId = changed.dataset.journalId;
    const side = changed.dataset.side;
    const url = changed.dataset.url;
    const totalCostTypeId = changed.dataset.totalCostTypeId;
    if (!rowId || !journalId || !side || !url || !totalCostTypeId) return;

    const rowChecks = document.querySelectorAll(`.allocation-checkbox[data-row-id='${rowId}']`);
    if (changed.checked && changed.dataset.landFlag === "false") {
      rowChecks.forEach((checkbox) => {
        if (checkbox !== changed) checkbox.checked = false;
      });
    } else if (changed.checked) {
      rowChecks.forEach((checkbox) => {
        if (checkbox.dataset.landFlag === "false") checkbox.checked = false;
      });
    }
    const selectedWorkTypeIds = Array.from(rowChecks)
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.dataset.workTypeId);

    const body = new URLSearchParams();
    body.append("journal_id", journalId);
    body.append("side", side);
    body.append("total_cost_type_id", totalCostTypeId);
    body.append("work_type_ids_present", "1");
    selectedWorkTypeIds.forEach((workTypeId) => {
      body.append("work_type_ids[]", workTypeId);
    });

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken(),
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
      },
      body: body.toString()
    })
    .then((res) => {
      if (!res.ok) return null;
      return res.text();
    })
    .then((html) => {
      if (!html) return;
      const group = document.getElementById(`row_group_${rowId}`);
      if (group) {
        group.outerHTML = html;
      }
    });
  };

  document.addEventListener("change", (event) => {
    const checkbox = event.target.closest(".allocation-checkbox");
    if (!checkbox) return;
    submitAllocation(checkbox);
  });

  document.addEventListener("click", (event) => {
    const button = event.target.closest(".toggle-allocation");
    if (!button) return;
    const targetId = button.dataset.target;
    if (!targetId) return;
    const detailRow = document.getElementById(targetId);
    if (!detailRow) return;
    detailRow.classList.toggle("d-none");
  });

  const totalModal = document.getElementById("total_modal");
  const totalForm = totalModal ? new bootstrap.Modal(totalModal) : null;
  const totalButton = document.getElementById("total_button");
  const totalClose = document.getElementById("total_close");
  if (!totalButton || !totalForm || !totalClose) return;

  totalClose.addEventListener("click", () => {
    totalForm.hide();
  });

  totalButton.addEventListener("click", (event) => {
    fetch(event.target.dataset.url)
    .then((res) => {
      if (res.ok) {
        return res.text();
      }
    })
    .then((data) => {
      document.getElementById("total_body").innerHTML = data;
      totalForm.show();
    });
  });
};
