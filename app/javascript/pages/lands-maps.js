import { Turbo } from "@hotwired/turbo-rails";
import { Decimal } from "decimal.js"

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
        strokeColor: land.dataset.color,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: land.dataset.color,
        fillOpacity: 0.35,
        landId: land.dataset.id,
        map: map
      });
  
      landRegions[land.dataset.id].addListener("mouseover", function(arg) {
        const land = document.getElementById("land_" + this.landId);
        document.getElementById("land_info").innerText = `${land.dataset.place}(${land.dataset.owner}):${land.dataset.area}a`;
      });
  
      landRegions[land.dataset.id].addListener("mouseout", function(arg) {
        document.getElementById("land_info").innerHTML = "&nbsp;";
      });
    });
  
    dispSum();
}
  
function dispSum() {
    const landAreas = {};
    document.getElementsByName("regions").forEach(function(land) {
      if(land.value != "") {
        landAreas[land.dataset.workType] = new Decimal(landAreas[land.dataset.workType] || 0);
        landAreas[land.dataset.workType] = landAreas[land.dataset.workType].plus(land.dataset.area);
      }
    });
    let sumArea = new Decimal(0);
    Object.keys(landAreas).forEach(function(key) {
      const landArea = document.getElementById(`land_area_${key}`);
      if (landArea != null) {
        landArea.innerText = landAreas[key].toFixed(1);
        sumArea = sumArea.plus(landAreas[key]);
      }
    });
}
  
export const init = () => {
    document.getElementById("target").addEventListener("blur", function() {
        Turbo.visit(`${target.dataset.url}?target=${this.value}`);
    });

    initMap();
};
