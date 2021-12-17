window.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-index='0']").forEach((element) => {
    element.style.display = "table-cell";
  });
  document.querySelectorAll("input[name$='magnification]']").forEach((element) => {
    element.addEventListener("change", (event) => {
      const group = event.target.dataset.group;
      const id = event.target.dataset.id;
      const unitScale = new Decimal(event.target.dataset.unit);
      const quantity = new Decimal(document.querySelector(`input[name='chemicals[${id}][${group}][quantity]']`).value);
      const mag = new Decimal(document.querySelector(`input[name='chemicals[${id}][${group}][magnification]']`).value);
      const dil = document.querySelector(`input[name='chemicals[${id}][${group}][dilution_amount]']`);

      dil.value = quantity.mul(mag).div(unitScale).toFixed(1);
    });
  });
  document.querySelectorAll("input[name$='dilution_amount]']").forEach((element) => {
    element.addEventListener("change", (event) => {
      const group = event.target.dataset.group;
      const id = event.target.dataset.id;
      const unitScale = new Decimal(event.target.dataset.unit);
      const quantity = new Decimal(document.querySelector(`input[name='chemicals[${id}][${group}][quantity]']`).value);
      const dil = new Decimal(document.querySelector(`input[name='chemicals[${id}][${group}][dilution_amount]']`).value);
      const mag = document.querySelector(`input[name='chemicals[${id}][${group}][magnification]']`);

      mag.value = dil.mul(unitScale).div(quantity).toFixed(1);
    });
  });
  document.querySelectorAll("input[name$='quantity]']").forEach((element) => {
    element.addEventListener("change", (event) => {
      const sumArea = new Decimal(document.getElementById("sum_areas").value);
      const quantity = new Decimal(event.target.value);
      document.getElementById(`chemicals_${event.target.dataset.id}_${event.target.dataset.index}_quantity10`).innerText = quantity.mul(10).div(sumArea).toFixed(1);
    });
  });
  document.querySelectorAll("input[name$='dilution_id]']").forEach((element) => {
    element.addEventListener("click", (event) => {
      const group = event.target.dataset.group;
      const id = event.target.dataset.id;
      const magnification = document.querySelector(`input[name='chemicals[${id}][${group}][magnification]']`);
      const dilutionAmount = document.querySelector(`input[name='chemicals[${id}][${group}][dilution_amount]']`);
      const DIL_NONE = parseInt(document.getElementById("dilution_none").value);
      const DIL_L = parseInt(document.getElementById("dilution_l").value);
      const DIL_MAG = parseInt(document.getElementById("dilution_mag").value);

      switch (parseInt(event.target.value)) {
        case DIL_NONE:
          magnification.disabled = true;
          magnification.value = "";
          dilutionAmount.disabled = true;
          dilutionAmount.value = "";
          break;
        case DIL_L:
          magnification.disabled = false;
          dilutionAmount.disabled = false;
          dilutionAmount.readOnly = false;
          magnification.readOnly = true;
          break;
        case DIL_MAG:
          magnification.disabled = false;
          dilutionAmount.disabled = false;
          dilutionAmount.readOnly = true;
          magnification.readOnly = false;
          break;
      }
    });
  });
  document.querySelectorAll(".change-group").forEach((e) => {
    e.addEventListener("change", (event) => {
      const group = event.target.dataset.group;
      document.querySelectorAll(".col-data").forEach((element) => {
        element.style.display = "none";
      });
      document.querySelectorAll(`[data-index="${group}"]`).forEach((element) => {
        element.style.display = "table-cell";
      });
    });
  });
});
