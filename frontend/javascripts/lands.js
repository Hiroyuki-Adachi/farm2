let landRegion;

function initMap(){
  const org = JSON.parse(document.getElementById("location").value);
  const pos = new google.maps.LatLng(org[0], org[1]);

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
      polygon.push("(" + path.lat() + "," + path.lng() + ")");
    });
    $("#land_region").val("(" + polygon.join(",") + ")");
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

window.addEventListener('load', (event) => {
  document.getElementById("clear_region").addEventListener("click", function() {
    if(landRegion) {
      landRegion.setMap(null);
      document.getElementById("land_region").value = "";
    }
  });
   
  initMap();
});
