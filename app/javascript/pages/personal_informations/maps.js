let map = null;
await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

window.initMap = function() {
    const org = JSON.parse(document.getElementById("location").value);
    const pos = {lat: org[0], lng: org[1]};

    map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      gestureHandling: "greedy",
      fullscreenControl: false,
      mapId: 'FARM2_MAP'
    });
    document.getElementById("map").style.setProperty("touch-action", "none", "important");
  
    new google.maps.marker.AdvancedMarkerElement({
      position: pos,
      title : document.getElementById("organization_name").value,
      map: map
    });
  
    document.querySelectorAll('[name="regions"]').forEach(function(land) {
      let paths = [];
      JSON.parse(land.value.replace(/\(/g, "[").replace(/\)/g, "]")).forEach(function(rg) {
        paths.push({lat: rg[0], lng: rg[1]});
      });
      new google.maps.Polygon({
        paths: paths,
        strokeColor: land.dataset.color,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: land.dataset.color,
        fillOpacity: 0.35,
        landId: land.dataset.id,
        map: map
      });

      const center = JSON.parse(land.dataset.center);
      const labelEl = document.createElement("div");
      labelEl.className = "map-label";
      labelEl.textContent = `${land.dataset.place}(${land.dataset.area}a)`;

      const marker = new google.maps.marker.AdvancedMarkerElement({
        position: { lat: center[0], lng: center[1] },
        map: map,
        content: labelEl,
        title: labelEl.textContent
      });
    });

  navigator.geolocation.getCurrentPosition((position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
    
      const myLatLng = { lat: lat, lng: lng };
  
      map.setCenter(myLatLng);
      map.setZoom(18);

      new google.maps.marker.AdvancedMarkerElement({
        position: myLatLng,
        map,
        title: "あなたの位置",
      });
  });
}

export const init = () => {
  initMap();
};
