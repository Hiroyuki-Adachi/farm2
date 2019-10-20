function add_worker(worker_id, worker_name)
{
    var tbody_workers = document.getElementById("tbody_workers");
    var row = tbody_workers.insertRow(tbody_workers.rows.length);

    row.id = "worker_" + worker_id.toString();

    var cell_no = row.insertCell(0);
    var cell_name = row.insertCell(1);
    var cell_time = row.insertCell(2);
    var cell_del = row.insertCell(3);

    var display_order = tbody_workers.rows.length ;

    cell_no.className = "numeric";
    cell_no.innerHTML = display_order;
    cell_name.innerHTML = worker_name;

    var elem_time = document.createElement("input");
    elem_time.type = "number";
    elem_time.value = get_hours();
    elem_time.name = "results[][hours]";
    elem_time.max = 99;
    elem_time.min = 0;
    elem_time.required = true;
    elem_time.step = 0.5;
    elem_time.className = "form-control form-control-sm";
    elem_time.style = "width: 75px;";
    cell_time.appendChild(elem_time);

    var elem_button = document.createElement("input")
    elem_button.type = "button";
    elem_button.value = "\u524a\u9664"; // 削除
    elem_button.className = "btn btn-outline-dark btn-sm";
    elem_button.onclick = new Function("remove_worker(" + worker_id + ");");
    cell_del.appendChild(elem_button);

    var elem_worker = document.createElement("input");
    elem_worker.type = "hidden";
    elem_worker.name = "results[][worker_id]";
    elem_worker.value = worker_id;
    cell_del.appendChild(elem_worker);

    var elem_order = document.createElement("input");
    elem_order.type = "hidden";
    elem_order.name = "results[][display_order]";
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
        row_worker.cells[3].children[2].value = i + 1;
    }
}

function get_hours()
{
    var dateFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    var start_time  = dateFormat.parse(document.getElementById("work_start_at").value.substring(0, 19));
    var end_time    = dateFormat.parse(document.getElementById("work_end_at").value.substring(0, 19));

    var start_hour = start_time.getHours();
    start_hour += parseFloat(start_time.getMinutes()) / 60.0;

    var end_hour = end_time.getHours();
    end_hour += parseFloat(end_time.getMinutes()) / 60.0;

    if((start_hour < 12) && (end_hour > 13)) end_hour-= 1.0;

    return (end_hour - start_hour).toFixed(1);
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
        var worker_id = tbody_workers.rows[i].cells[3].children[1].value;
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

$(function() {
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

  $("input[type='radio'][name='section']").change(function() {
    change_section($(this)[0])
  });
});
