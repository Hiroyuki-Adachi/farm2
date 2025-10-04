let map = null;

window.initMap = function() {
    const org = JSON.parse(document.getElementById("location").value);
    const pos = new google.maps.LatLng(org[0], org[1]);

    map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      gestureHandling: "greedy",
      fullscreenControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    document.getElementById("map").style.setProperty("touch-action", "none", "important");
  
    new google.maps.Marker({
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
      new google.maps.Marker({
        position: { lat: center[0], lng: center[1] },
        map: map,
        label: {
          text: `${land.dataset.place}(${land.dataset.area}a)`,
          fontSize: "20px"   // フォントサイズ！
        },
        icon: {
          path: google.maps.SymbolPath.CIRCLE,
          scale: 0, // アイコンを透明にしてラベルだけ表示
        }
      });
    });

  navigator.geolocation.getCurrentPosition((position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
    
      const myLatLng = { lat: lat, lng: lng };
  
      map.setCenter(myLatLng);
      map.setZoom(18);
      
      new google.maps.Marker({
        position: myLatLng,
        map,
        title: "あなたの位置",
      });
  });
}

export const init = () => {
  initMap();
};
