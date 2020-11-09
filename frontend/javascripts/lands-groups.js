const { default: Decimal } = require("decimal.js");

function removeLand(landId)
{
    document.getElementById("tbody_lands").deleteRow(document.getElementById("land_" + landId.toString()).rowIndex - 1);

    renumberLand();
}

function renumberLand()
{
    const tbodyLands = document.getElementById("tbody_lands");
    for(let i = 0; i < tbodyLands.rows.length; i++)
    {
        const rowLand = tbodyLands.rows[i];
        rowLand.cells[0].innerHTML = i + 1;
        rowLand.cells[4].children[2].value = i + 1;
    }
}

function calcTotalArea()
{
    const tbodyLands = document.getElementById("tbody_lands");
    let totalArea = new Decimal(0);

    for(let i = 0; i < tbodyLands.rows.length; i++)
    {
        totalArea = totalArea.plus(tbodyLands.rows[i].cells[3].innerHTML);
    }

    document.getElementById("land_area").value = totalArea.toFixed(1);
}

function addLand(landId, landPlace, landOwner, landArea)
{
    if(document.getElementById("land_" + landId))
    {
        bootbox.alert("既に存在しています(" + landPlace + ")");
        document.getElementById("land_place").value = "";
        return;
    }

    const tbodyLands = document.getElementById("tbody_lands");
    const row = tbodyLands.insertRow(tbodyLands.rows.length);

    row.id = "land_" + landId.toString();

    const cellNo     = row.insertCell(0);
    const cellPlace  = row.insertCell(1);
    const cellOwner  = row.insertCell(2);
    const cellArea   = row.insertCell(3);
    const cellDel    = row.insertCell(4);

    const displayOrder = tbodyLands.rows.length;

    cellNo.className = "numeric";
    cellNo.innerHTML = displayOrder;
    cellPlace.innerHTML = landPlace;
    cellOwner.innerHTML = landOwner;
    cellArea.className = "numeric";
    cellArea.innerHTML = parseFloat(landArea).toFixed(1);

    const elemButton = document.createElement("input")
    elemButton.type = "button";
    elemButton.className = "btn btn-outline-dark btn-sm remove-land";
    elemButton.value = "削除";
    elemButton.dataset.land = landId;
    cellDel.appendChild(elemButton);

    const elemLand = document.createElement("input");
    elemLand.type = "hidden";
    elemLand.name = "members[][land_id]";
    elemLand.value = landId;
    cellDel.appendChild(elemLand);

    const elemOrder = document.createElement("input");
    elemOrder.type = "hidden";
    elemOrder.name = "members[][display_order]";
    elemOrder.value = displayOrder;
    cellDel.appendChild(elemOrder);

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
      renumberLand();
    }
  });

  $("#tbody_lands").on("click", ".remove-land", function() {
    removeLand($(this).data("land"));
  });

  $("#land").autocomplete({
    source : $("#autocomplete_lands_groups_path").val(),
    minLength: 2,
    select: function(e, ui) {
      if(ui.item) {
        addLand(ui.item.details.id, ui.item.details.place, ui.item.details.owner, ui.item.details.area);
      }
      return false;
    }
  });

  document.getElementById("re_calc").addEventListener('click', function() {
    calcTotalArea();
  });
});
