import Sortable from "sortablejs";

function addWorker(workerId)
{
    if(document.getElementById(`worker_${workerId}`) != null) return;  // 既に存在する場合、追加は無効

    const tbodyWorkers = document.getElementById("tbody_workers");
    const row = tbodyWorkers.insertRow(tbodyWorkers.rows.length);

    row.id = `worker_${workerId}`;

    const cellNo = row.insertCell(0);
    const cellName = row.insertCell(1);
    const cellDel = row.insertCell(2);

    const displayOrder = tbodyWorkers.rows.length ;

    cellNo.className = "numeric";
    cellNo.innerHTML = displayOrder;
    cellName.innerHTML = document.getElementById(`master_worker_${workerId}`).cells[2].innerText;

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
    elemWorker.name = "schedule_workers[][worker_id]";
    elemWorker.value = workerId;
    cellDel.appendChild(elemWorker);

    const elemOrder = document.createElement("input");
    elemOrder.type = "hidden";
    elemOrder.name = "schedule_workers[][display_order]";
    elemOrder.value = displayOrder;
    cellDel.appendChild(elemOrder);

    setAddButtons();
}

function removeWorker(workerId)
{
    const tblWorkers = document.getElementById("tbl_workers");
    const trWorker = document.getElementById(`worker_${workerId}`);

    tblWorkers.deleteRow(trWorker.rowIndex);
    renumberWorker();
    setAddButtons();
}

function renumberWorker()
{
    const tbodyWorkers = document.getElementById("tbody_workers");
    for(let i = 0; i < tbodyWorkers.rows.length; i++) {
        const row_worker = tbodyWorkers.rows[i];
        row_worker.cells[0].innerHTML = i + 1;
        row_worker.cells[2].children[2].value = i + 1;
    }
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
        const workerId = tbodyWorkers.rows[i].cells[2].children[1].value;
        document.getElementById(`add_button_${workerId}`).disabled = true;
        document.getElementById(`master_worker_${workerId}`).style.backgroundColor = "lightgrey";
    }
}

function changeSection(section) {
    const workers = document.getElementById("master_workers");

    for(let i = 0; i < workers.rows.length; i++) {
        const workerTr = workers.rows[i];
        workerTr.style.display = "";
        if(parseInt(section.value) != 0 && parseInt(workerTr.cells[3].innerText) != parseInt(section.value)) {
            workerTr.style.display = "none";
        }
    }
}

function addSection(sectionId) {
    const workers = document.getElementById("master_workers");

    for(let i = 0; i < workers.rows.length; i++) {
        const workerTr = master_workers.rows[i];
        if((parseInt(workerTr.cells[3].innerText) == sectionId) && (workerTr.cells[4].innerText != "None")) {
            addWorker(workerTr.id.replace("master_worker_", ""));
        }
    }
}

function addPositions(positions) {
    const workers = document.getElementById("master_workers");

    for(var i = 0; i < workers.rows.length; i++) {
        const workerTr = workers.rows[i];
        if(positions.indexOf(workerTr.cells[4].innerText) >= 0) {
            addWorker(workerTr.id.replace("master_worker_", ""));
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
            addWorker(event.target.dataset.worker);
        });
    });

    document.querySelectorAll(".remove-worker").forEach((element) => {
        element.addEventListener("click", (event) => {
            removeWorker(event.target.dataset.worker);
        });
    });

    document.querySelectorAll(".add-members").forEach((element) => {
        element.addEventListener("click", (event) => {
            addPositions(JSON.parse(event.target.dataset.positions));
        });
    });

    document.querySelectorAll(".add-section").forEach((element) => {
        element.addEventListener("click", (event) => {
            addSection(event.target.dataset.section);
        });
    });
};
