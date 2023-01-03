import "jquery-ui/ui/widgets/sortable";

function add_worker(worker_id)
{
    if(document.getElementById("worker_" + worker_id) != null) return;  // 既に存在する場合、追加は無効

    var tbody_workers = document.getElementById("tbody_workers");
    var row = tbody_workers.insertRow(tbody_workers.rows.length);

    row.id = "worker_" + worker_id.toString();

    var cell_no = row.insertCell(0);
    var cell_name = row.insertCell(1);
    var cell_del = row.insertCell(2);

    var display_order = tbody_workers.rows.length ;

    cell_no.className = "numeric";
    cell_no.innerHTML = display_order;
    cell_name.innerHTML = document.getElementById("master_worker_" + worker_id).cells[2].innerText;

    var elem_button = document.createElement("input")
    elem_button.type = "button";
    elem_button.value = "\u524a\u9664"; // 削除
    elem_button.className = "btn btn-outline-dark btn-sm remove-worker";
    elem_button.dataset.worker = worker_id;
    cell_del.appendChild(elem_button);

    var elem_worker = document.createElement("input");
    elem_worker.type = "hidden";
    elem_worker.name = "schedule_workers[][worker_id]";
    elem_worker.value = worker_id;
    cell_del.appendChild(elem_worker);

    var elem_order = document.createElement("input");
    elem_order.type = "hidden";
    elem_order.name = "schedule_workers[][display_order]";
    elem_order.value = display_order;
    cell_del.appendChild(elem_order);

    set_add_buttons();
}

function remove_worker(worker_id)
{
    var tbl_workers = document.getElementById("tbl_workers");
    var tr_worker = document.getElementById("worker_" + worker_id.toString());

    tbl_workers.deleteRow(tr_worker.rowIndex);
    renumber_worker();
    set_add_buttons();
}

function renumber_worker()
{
    var tbody_workers = document.getElementById("tbody_workers");
    var row_worker;
    for(var i = 0; i < tbody_workers.rows.length; i++)
    {
        row_worker = tbody_workers.rows[i];
        row_worker.cells[0].innerHTML = i + 1;
        row_worker.cells[2].children[2].value = i + 1;
    }
}

function set_add_buttons()
{
    var master_workers = document.getElementById("master_workers");
    var tbody_workers = document.getElementById("tbody_workers");
    var i;

    for(i = 0; i < master_workers.rows.length; i++)
    {
        master_workers.rows[i].cells[0].children[0].disabled = false;
        master_workers.rows[i].style.backgroundColor = "White";
    }

    for(i = 0; i < tbody_workers.rows.length; i++)
    {
        var worker_id = tbody_workers.rows[i].cells[2].children[1].value;
        document.getElementById("add_button_" + worker_id).disabled = true;
        document.getElementById("master_worker_" + worker_id).style.backgroundColor = "lightgrey";
    }
}

function change_section(section) {
    var workers = document.getElementById("master_workers");
    var worker_tr;

    for(var i = 0; i < workers.rows.length; i++) {
        worker_tr = master_workers.rows[i];
        worker_tr.style.display = "";
        if(parseInt(section.value) != 0 && parseInt(worker_tr.cells[3].innerText) != parseInt(section.value)) {
            worker_tr.style.display = "none";
        }
    }
}

function add_section(section_id) {
    var workers = document.getElementById("master_workers");
    var worker_tr;

    for(var i = 0; i < workers.rows.length; i++) {
        worker_tr = master_workers.rows[i];
        if((parseInt(worker_tr.cells[3].innerText) == section_id) && (worker_tr.cells[4].innerText != "None")) {
            add_worker(worker_tr.id.replace("master_worker_", ""));
        }
    }
}

function add_positions(positions) {
    var workers = document.getElementById("master_workers");
    var worker_tr;

    for(var i = 0; i < workers.rows.length; i++) {
        worker_tr = master_workers.rows[i];
        if(positions.indexOf(worker_tr.cells[4].innerText) >= 0) {
            add_worker(worker_tr.id.replace("master_worker_", ""));
        }
    }
}

window.addEventListener('turbo:load', () => {
  set_add_buttons();

  $("#tbody_workers tr").hover(function() {
    $(this).css("cursor", "crosshair");
  }, function() {
    $(this).css("cursor", "default");
  });
    
  $("#tbody_workers").sortable({
    cursor: "move",
    update: function(e, ui) {
      renumber_worker();
    }
  });

  $(".add-worker").on('click', function() {
    add_worker($(this).data("worker"));
  });
  $("#tbody_workers").on('click', ".remove-worker", function() {
    remove_worker($(this).data("worker"));
  });
  $("#add_director").on('click', function() {
    add_positions(["Director"]);
  });
  $("#add_leader").on('click', function() {
    add_positions(["Director", "Leader"]);
  });
  $("#add_member").on('click', function() {
    add_positions(["Director", "Leader", "Member"]);
  });
  $(".add-section").on('click', function() {
    add_section($(this).data("section"));
  });

  $("input[type='radio'][name='section']").change(function() {
    change_section($(this)[0])
  });
});
