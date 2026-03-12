import { Decimal } from "decimal.js";

export const init = () => {
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
      calcQuantity10(event.target);
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
  document.querySelectorAll(".change-group").forEach((group) => {
    group.addEventListener("change", (event) => {
          const group = parseInt(event.target.dataset.group);
          document.querySelectorAll(".col-data").forEach((element) => {
              element.style.display = "none";
          });
          document.querySelectorAll(`[data-index="${group}"]`).forEach((element) => {
              element.style.display = "table-cell";
          });
          Array.from(document.getElementsByClassName("chemical-land")).forEach((element) => {
              element.value = group + 1;
              element.checked = (document.getElementById(element.dataset.id).value == group + 1);
          });
          calcGroupAreas();
          calcAllQuantity10();
      });
  });
  document.getElementById("work_chemical_group_flag").addEventListener("change", (event) => {
      document.getElementById("lands").style.display = event.target.checked ? "block" : "none";
      calcGroupAreas();
      calcAllQuantity10();
  });
  Array.from(document.getElementsByClassName("chemical-land")).forEach((element) => {
      element.addEventListener("change", (event) => {
          document.getElementById(event.target.dataset.id).value = event.target.checked ? event.target.value : 0;
          calcGroupAreas();
          calcAllQuantity10();
      });
  });
};

function calcGroupAreas()
{
    if (document.getElementById("work_chemical_group_flag").checked) {
        let groupAreas = new Decimal(0);
        const group = parseInt(document.querySelector(".change-group:checked").value) + 1;
        document.querySelectorAll(".chemical-land:checked").forEach((element) => {
            groupAreas = groupAreas.plus(new Decimal(element.dataset.area));
        });
        document.getElementById(`group_areas_${group}`).value = groupAreas.toFixed(1);
        document.getElementById("group_areas_span").innerText = document.getElementById(`group_areas_${group}`).value;
      } else {
        document.getElementById("group_areas_span").innerText = document.getElementById("sum_areas").value;
    }
}

function calcQuantity10(element)
{
    const target = document.getElementById(`chemicals_${element.dataset.id}_${element.dataset.index}_quantity10`);
    if (element.value == "") {
        target.innerText = "";
        return;
    }
    let sumArea = null;
    if (document.getElementById("work_chemical_group_flag").checked) {
        const group = parseInt(document.querySelector(".change-group:checked").value) + 1;
        sumArea = new Decimal(document.getElementById(`group_areas_${group}`).value);
    } else {
        sumArea = new Decimal(document.getElementById("sum_areas").value);
    }
    const quantity = new Decimal(element.value);
    target.innerText = sumArea.isZero() ? "" : quantity.mul(10).div(sumArea).toFixed(1);
}

function calcAllQuantity10()
{
  const group = parseInt(document.querySelector(".change-group:checked").value) + 1;
    document.querySelectorAll(`input[name$="quantity]"][data-index="${group}"]`).forEach((element) => {
        calcQuantity10(element);
    });
}