function initMap(){
    const org = JSON.parse(document.getElementById("location").value);
    const pos = new google.maps.LatLng(org[0], org[1]);
  
    const map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
  
    const marker = new google.maps.Marker({
      position: pos,
      title : document.getElementById("organization_name").value,
      map: map
    });
  
    let landRegions = {};
    document.getElementsByName("regions").forEach(function(land) {
      let paths = [];
      JSON.parse(land.value.replace(/\(/g, "[").replace(/\)/g, "]")).forEach(function(rg) {
        paths.push({lat: rg[0], lng: rg[1]});
      });
      landRegions[land.dataset.id] = new google.maps.Polygon({
        paths: paths,
        strokeColor: "#339933",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#339933",
        fillOpacity: 0.35,
        landId: land.dataset.id,
        map: map
      });
  
      landRegions[land.dataset.id].addListener("mouseover", function(arg) {
        const land = document.getElementById("land_" + this.landId);
        document.getElementById("land_info").innerText = `${land.dataset.place}(${land.dataset.owner}):${land.dataset.area}a`;
      });
  
      landRegions[land.dataset.id].addListener("mouseout", function(arg) {
        document.getElementById("land_info").innerText = "";
      });
    });
}

export const init = () => {
  initMap();
};
