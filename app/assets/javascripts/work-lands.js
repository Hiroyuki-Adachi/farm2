function remove_land(land_id)
{
    document.getElementById("tbody_lands").deleteRow(document.getElementById("land_" + land_id.toString()).rowIndex - 1);

    renumber_land();
    calc_total_area();
}

function renumber_land()
{
    var tbody_lands = document.getElementById("tbody_lands");
    var row_land;
    for(var i = 0; i < tbody_lands.rows.length; i++)
    {
        row_land = tbody_lands.rows[i];
        row_land.cells[0].innerHTML = i + 1;
        row_land.cells[3].children[2].value = i + 1;
    }
}

function calc_total_area()
{
    var tbody_lands = document.getElementById("tbody_lands");
    var total_area = 0.0;

    for(var i = 0; i < tbody_lands.rows.length; i++)
    {
        total_area += parseFloat(tbody_lands.rows[i].cells[2].innerHTML);
    }

    document.getElementById("total_area").innerHTML = total_area.toFixed(2);
}

function add_land(land_id, land_place, land_area)
{
    if(document.getElementById("land_" + land_id))
    {
        alert("既に存在しています(" + land_place + ")");
        document.getElementById("land_place").value = "";
        return;
    }

    var tbody_lands = document.getElementById("tbody_lands");
    var row = tbody_lands.insertRow(tbody_lands.rows.length);

    row.id = "land_" + land_id.toString();

    var cell_no     = row.insertCell(0);
    var cell_place  = row.insertCell(1);
    var cell_area   = row.insertCell(2);
    var cell_del    = row.insertCell(3);

    var display_order = tbody_lands.rows.length;

    cell_no.className = "numeric";
    cell_no.innerHTML = display_order;

    cell_place.innerHTML = land_place;

    cell_area.className = "numeric";
    cell_area.innerHTML = parseFloat(land_area).toFixed(1);

    var elem_button = document.createElement("input")
    elem_button.type = "button";
    elem_button.value = "削除";
    elem_button.onclick = new Function("remove_land(" + land_id + ");");
    cell_del.appendChild(elem_button);

    var elem_land = document.createElement("input");
    elem_land.type = "hidden";
    elem_land.name = "work_lands[][land_id]";
    elem_land.value = land_id;
    cell_del.appendChild(elem_land);

    var elem_order = document.createElement("input");
    elem_order.type = "hidden";
    elem_order.name = "work_lands[][display_order]";
    elem_order.value = display_order;
    cell_del.appendChild(elem_order);

    calc_total_area();

    $("#land").val("");
}

$(function() {
  $("#tbody_lands tr").hover(function() {
    $(this).css("cursor", "crosshair");
  }, function() {
    $(this).css("cursor", "default");
  });
    
  $("#tbody_lands").sortable({
    cursor: "move",
    update: function(e, ui) {
      renumber_land();
    }
  });

  $("#tbody_lands").disableSelection();
});
