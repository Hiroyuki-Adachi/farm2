import AutoComplete from "@tarekraafat/autocomplete.js";
import Decimal from "decimal.js";
import Sortable from "sortablejs";

function removeLand(landId)
{
    document.getElementById("tbody_lands").deleteRow(document.getElementById(`land_${landId}`).rowIndex - 1);

    renumberLand();
    calcTotalArea();
}

function renumberLand()
{
    const tbodyLands = document.getElementById("tbody_lands");
    for(let i = 0; i < tbodyLands.rows.length; i++)
    {
        const rowLand = tbodyLands.rows[i];
        rowLand.cells[0].innerHTML = i + 1;
        rowLand.cells[3].children[2].value = i + 1;
    }
}

function calcTotalArea()
{
    const tbodyLands = document.getElementById("tbody_lands");
    let totalArea = new Decimal(0);

    for(let i = 0; i < tbodyLands.rows.length; i++) {
      totalArea = totalArea.plus(new Decimal(tbodyLands.rows[i].cells[2].innerHTML));
    }

    document.getElementById("total_area").innerHTML = totalArea.toFixed(2);
}

function addLand(landId, landPlace, landArea)
{
    if(document.getElementById(`land_${landId}`))
    {
        popupAlert(`既に存在しています(${landPlace})`);
        document.getElementById("land_place").value = "";
        return;
    }

    const tbodyLands = document.getElementById("tbody_lands");
    const row = tbodyLands.insertRow(tbodyLands.rows.length);

    row.id = `land_${landId}`;

    const cellNo    = row.insertCell(0);
    const cellPlace = row.insertCell(1);
    const cellArea  = row.insertCell(2);
    const cellDel   = row.insertCell(3);

    const displayOrder = tbodyLands.rows.length;

    cellNo.className = "numeric";
    cellNo.innerHTML = displayOrder;

    cellPlace.innerHTML = landPlace;

    cellArea.className = "numeric";
    cellArea.innerHTML = parseFloat(landArea).toFixed(2);

    const elemButton = document.createElement("input");
    elemButton.type = "button";
    elemButton.className = "btn btn-outline-dark btn-sm remove-land";
    elemButton.value = "削除";
    elemButton.dataset.land = landId;
    elemButton.addEventListener("click", (event) => {
        removeLand(event.target.dataset.land);
    });
    cellDel.appendChild(elemButton);

    const elemLand = document.createElement("input");
    elemLand.type = "hidden";
    elemLand.name = "work_lands[][land_id]";
    elemLand.value = landId;
    cellDel.appendChild(elemLand);

    const elemOrder = document.createElement("input");
    elemOrder.type = "hidden";
    elemOrder.name = "work_lands[][display_order]";
    elemOrder.value = displayOrder;
    cellDel.appendChild(elemOrder);

    calcTotalArea();

    document.getElementById("land").value = "";
}

window.addEventListener('turbo:load', () => {
    Sortable.create(document.getElementById("tbody_lands"), {
        onSort: renumberLand
    });

    document.querySelectorAll(".remove-land").forEach((element) => {
        element.addEventListener("click", (event) => {
            removeLand(event.target.dataset.land);
        });
    });

    calcTotalArea();

    const autoCompleteJs = new AutoComplete({
        data: {
            src: fetch(document.getElementById("autocomplete_work_lands_path").value).then(h=>h.json()),
            keys: ["place", "area"],
            cache: true
        },
        selector: "#land",
        threshold: 2,
        resultsList: {
            maxResults: 20
        },
        resultItem: {
            element: (item, data) => {
                item.innerHTML = `${data.value.place}(${data.value.owner})(${data.value.area})`;
            },
            highlight: true
        },
        events: {
            input: {
                selection: (event) => {
                    const target = event.detail.selection.value;
                    addLand(target.id, `${target.place}(${target.owner})`, target.area);
                }
            }
        }
    });
});
