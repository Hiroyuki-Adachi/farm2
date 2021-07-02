window.addEventListener("DOMContentLoaded", (event) => {
  document.querySelectorAll("[data-index='0']").forEach((element) => {
    element.style.display = "table-cell";
  });
  document.querySelectorAll("input[name$='magnification]'], input[name$='dilution_amount]']").forEach((element) => {
    element.addEventListener("change", (event) => {
      const index = event.target.dataset.index;
      const id = event.target.dataset.id;
      const unitScale = new Decimal(event.target.dataset.unit);
      const magnification = new Decimal(document.querySelector(`input[name='chemicals[${id}][${index}][magnification]']`).value);
      const dilutionAmount = new Decimal(document.querySelector(`input[name='chemicals[${id}][${index}][dilution_amount]']`).value);
      const quantity = document.querySelector(`input[name='chemicals[${id}][${index}][quantity]']`);
        
      quantity.value = dilutionAmount.div(magnification).mul(unitScale).toFixed(1);
      changeQuantity(quantity);
    });
  });
  document.querySelectorAll("input[name$='quantity]']").forEach((element) => {
    element.addEventListener("change", (event) => {
      changeQuantity(event.target);
    });
  });
  document.querySelectorAll("input[name$='aqueous_flag]']").forEach((element) => {
    element.addEventListener("click", (event) => {
      const index = event.target.dataset.index;
      const id = event.target.dataset.id;
      const magnification = document.querySelector(`input[name='chemicals[${id}][${index}][magnification]']`);
      const dilutionAmount = document.querySelector(`input[name='chemicals[${id}][${index}][dilution_amount]']`);
      const quantity = document.querySelector(`input[name='chemicals[${id}][${index}][quantity]']`);

      if (event.target.checked) {
        magnification.disabled = false;
        dilutionAmount.disabled = false;
        quantity.readOnly = true;
      } else {
        magnification.disabled = true;
        magnification.value = "";
        dilutionAmount.disabled = true;
        dilutionAmount.value = "";
        quantity.readOnly = false;
      }
    });
  });
});

function changeGroup(group)
{
  document.querySelectorAll(".col-data").forEach((element) => {
    element.style.display = "none";
  });
  document.querySelectorAll(`[data-index="${group}"]`).forEach((element) => {
    element.style.display = "table-cell";
  });
}

function changeQuantity(target)
{
  const sumArea = new Decimal(document.getElementById("sum_areas").value);
  const quantity = new Decimal(target.value);
  document.getElementById(`chemicals_${target.dataset.id}_${target.dataset.index}_quantity10`).innerText = quantity.mul(10).div(sumArea).toFixed(1);
}
