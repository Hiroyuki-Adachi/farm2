await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

function initMap(){
    const location = document.getElementById("home_location");
    const home = JSON.parse(location.value.replace("(", "[").replace(")", "]"));
    const pos = {lat: home[0], lng: home[1]};

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
      // もとの "(lat, lng)" 形式に合わせて保存
      location.value = `(${event.latLng.lat().toFixed(6)}, ${event.latLng.lng().toFixed(6)})`;
    });
}

export const init = () => {
    initMap();
};
