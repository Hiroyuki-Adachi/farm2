import "bootstrap";

let landRegion;

async function initMap(){
  await google.maps.importLibrary("drawing");
  const org = JSON.parse(document.getElementById("location").value);
  const pos = {lat: org[0], lng: org[1]};

  const map = new google.maps.Map(document.getElementById('map'), {
    center: pos,
    zoom: 18,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  });

  landRegion = new google.maps.Polygon({
    paths: convertRegion(document.getElementById("land_region").value),
    strokeColor: "#FF0000",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#FF0000",
    fillOpacity: 0.35,
    map: map
  });

  const otherRegions = []
  document.getElementsByName("other_lands").forEach(function(other) {
    otherRegions.push(new google.maps.Polygon({
        paths: convertRegion(other.value),
        strokeColor: "#ffffff",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#ffffff",
        fillOpacity: 0.35,
        map: map
    }));
  }); 

  const drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.POLYGON,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: [google.maps.drawing.OverlayType.POLYGON]
    },
    polygonOptions: {
      fillColor: '#99ff99',
      strokeColor: "#99ff99",
      editable: true
    },
    map: map
  });

  google.maps.event.addListener(drawingManager, 'polygoncomplete', function(arg) {
    let polygon = [];
    arg.getPath().getArray().forEach(function(path) {
      polygon.push(`(${path.lat()},${path.lng()})`);
    });
    document.getElementById("land_region").value = `(${polygon.join(",")})`;
  });
}

function convertRegion(region) {
  if(region == "") {
    return [];
  }

  const results = [];
  JSON.parse(region.replace(/\(/g, "[").replace(/\)/g, "]")).forEach(function(rg) {
    results.push({lat: rg[0], lng: rg[1]});
  });
  return results;
}

export const init = () => {
  document.getElementById("clear_region").addEventListener("click", function() {
    if(landRegion) {
      landRegion.setMap(null);
      document.getElementById("land_region").value = "";
    }
  });

  let popForm = null;
  document.querySelectorAll(".edit-homes").forEach((element) => {
    element.addEventListener("click", (event) => {
      popForm = new bootstrap.Modal(document.getElementById("popup_edit"));
      document.getElementById("destroy_path").value = event.target.dataset.updatePath;
      document.getElementById("index_path").value = event.target.dataset.path;
      popupModal(event.target.dataset.path, () => {
        popForm.show();
        popForm._isTransitioning= false;
      });
    });
  });

  document.getElementById("popup_update").addEventListener("click", () => {
    fetch(document.getElementById("index_path").value, {
      method: "POST",
      body: new FormData(document.getElementById("update_form"))
    })
    .then(() => {
      popupModal(document.getElementById("index_path").value)
    });

  });
  document.getElementById("popup_close").addEventListener("click", () => {
    popForm.hide();
  });
  document.getElementById("popup_delete").addEventListener("click", () => {
    popupConfirm("表示中のデータを削除してもよろしいですか？", (result) => {
      if (result) {
        popForm.hide();
      }
    });
  });
  initMap();
};

function popupModal(action, callback) {
  fetch(action)
  .then((data) => data.text())
  .then((html) => {
      document.getElementById("popup_content").innerHTML = html;

      if (callback) {
        callback();
      }
  });
}
