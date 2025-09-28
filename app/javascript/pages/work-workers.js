import Sortable from "sortablejs";
import Moment from "moment";

function addWorker(workerId, worker_name)
{
    const tbodyWorkers = document.getElementById("tbody_workers");
    const row = tbodyWorkers.insertRow(tbodyWorkers.rows.length);

    row.id = `worker_${workerId}`;

    const cellNo = row.insertCell(0);
    const cellName = row.insertCell(1);
    const cellTime = row.insertCell(2);
    const cellDel = row.insertCell(3);

    const displayOrder = tbodyWorkers.rows.length ;

    cellNo.className = "numeric";
    cellNo.innerHTML = displayOrder;
    cellName.innerHTML = worker_name;

    const elemTime = document.createElement("input");
    elemTime.type = "number";
    elemTime.value = getHours();
    elemTime.name = "results[][hours]";
    elemTime.max = 99;
    elemTime.min = 0;
    elemTime.required = true;
    elemTime.step = 0.5;
    elemTime.className = "form-control form-control-sm";
    elemTime.style.width = "75px";
    cellTime.appendChild(elemTime);

    const elemButton = document.createElement("input")
    elemButton.type = "button";
    elemButton.value = "\u524a\u9664"; // 削除
    elemButton.className = "btn btn-outline-dark btn-sm remove-worker";
    elemButton.dataset.worker = workerId;
    cellDel.appendChild(elemButton);
    elemButton.addEventListener("click", (event) => {
        removeWorker(event.target.dataset.worker);
    });

    const elemWorker = document.createElement("input");
    elemWorker.type = "hidden";
    elemWorker.name = "results[][worker_id]";
    elemWorker.value = workerId;
    cellDel.appendChild(elemWorker);

    const elemOrder = document.createElement("input");
    elemOrder.type = "hidden";
    elemOrder.name = "results[][display_order]";
    elemOrder.value = displayOrder;
    cellDel.appendChild(elemOrder);

    setAddButtons();
}

function removeWorker(workerId)
{
    const tblWorkers = document.getElementById("tbl_workers");
    const trWorker = document.getElementById("worker_" + workerId.toString());

    tblWorkers.deleteRow(trWorker.rowIndex);
    renumberWorker();
    setAddButtons();
}

function renumberWorker()
{
    const tbodyWorkers = document.getElementById("tbody_workers");
    for(let i = 0; i < tbodyWorkers.rows.length; i++) {
        const rowWorker = tbodyWorkers.rows[i];
        rowWorker.cells[0].innerHTML = i + 1;
        rowWorker.cells[3].children[2].value = i + 1;
    }
}

function getHours()
{
    const startTime  = Moment(document.getElementById("work_start_at").value.substring(0, 19), "yyyy-MM-dd HH:mm:ss").toDate();
    const endTime    = Moment(document.getElementById("work_end_at").value.substring(0, 19), "yyyy-MM-dd HH:mm:ss").toDate();

    let startHour = startTime.getHours();
    startHour += parseFloat(startTime.getMinutes()) / 60.0;

    let endHour = endTime.getHours();
    endHour += parseFloat(endTime.getMinutes()) / 60.0;

    if((startHour < 12) && (endHour > 13)) endHour -= 1.0;

    return (endHour - startHour).toFixed(1);
}

function setAddButtons()
{
    const masterWorkers = document.getElementById("master_workers");
    const tbodyWorkers = document.getElementById("tbody_workers");

    for(let i = 0; i < masterWorkers.rows.length; i++) {
        masterWorkers.rows[i].cells[0].children[0].disabled = false;
        masterWorkers.rows[i].style.backgroundColor = "White";
    }

    for(let i = 0; i < tbodyWorkers.rows.length; i++) {
        const workerId = tbodyWorkers.rows[i].cells[3].children[1].value;
        document.getElementById(`add_button_${workerId}`).disabled = true;
        document.getElementById(`master_worker_${workerId}`).style.backgroundColor = "lightgrey";
    }
}

function changeSection(section) {
    const masterWorkers = document.getElementById("master_workers");

    for(let i = 0; i < masterWorkers.rows.length; i++) {
        const trWorker = masterWorkers.rows[i];
        trWorker.style.display = "";
        if(parseInt(section.value) != 0 && parseInt(trWorker.cells[3].innerText) != parseInt(section.value)) {
            trWorker.style.display = "none";
        }
    }
}

export const init = () => {
    setAddButtons();

    Sortable.create(document.getElementById("tbody_workers"), {
        onSort: renumberWorker
    });

    document.querySelectorAll("input[type='radio'][name='section']").forEach((element) => {
        element.addEventListener("change", (event) => {
            changeSection(event.target);
        });
    });

    document.querySelectorAll(".add-worker").forEach((element) => {
        element.addEventListener("click", (event) => {
            addWorker(event.target.dataset.worker, event.target.dataset.name);
        });
    });

    document.querySelectorAll(".remove-worker").forEach((element) => {
        element.addEventListener("click", (event) => {
            removeWorker(event.target.dataset.worker);
        });
    });
}
