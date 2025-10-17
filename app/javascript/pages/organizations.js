await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

function initMap(){
    const location = document.getElementById("organization_location");
    const org = JSON.parse(location.value.replace("(", "[").replace(")", "]"));
    const pos = {lat: org[0], lng: org[1]};

    const map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      mapId: 'FARM2_MAP'
    });

    const marker = new google.maps.marker.AdvancedMarkerElement({
      position: pos,
      gmpDraggable: true,
      map: map
    });

    marker.addListener("dragend", function(event) {
      location.value = `(${event.latLng.lat().toFixed(6)}, ${event.latLng.lng().toFixed(6)})`;
    });
}

export const init = () => {
  initMap();
};
