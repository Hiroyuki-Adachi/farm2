let selectedWorkType;

function initMap(){
  const org = JSON.parse(document.getElementById("location").value);
  const pos = new google.maps.LatLng(org[0], org[1]);
  const DEFAULT_COLOR = "#000000";

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

  const workTypes = {};
  Array.from(document.getElementById("work_types").getElementsByTagName("input")).forEach(function(workType) {
    workTypes[workType.dataset.id] = workType.dataset.bgColor;
  });

  const landRegions = {};
  Array.from(document.getElementById("lands").getElementsByTagName("input")).forEach(function(land) {
    const paths = [];
    JSON.parse(land.dataset.region.replace(/\(/g, "[").replace(/\)/g, "]")).forEach(function(rg) {
      paths.push({lat: rg[0], lng: rg[1]});
    });
    const workType = workTypes[land.value];
    landRegions[land.dataset.id] = new google.maps.Polygon({
      paths: paths,
      strokeColor: workType == null ? DEFAULT_COLOR : workType,
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: workType == null ? DEFAULT_COLOR : workType,
      fillOpacity: 0.35,
      landId: land.dataset.id,
      map: map
    });

    landRegions[land.dataset.id].addListener("click", function(arg) {
      this.setOptions({
        strokeColor: selectedWorkType.dataset.bgColor,
        fillColor: selectedWorkType.dataset.bgColor
      });
      document.getElementById("land_" + this.landId).value = selectedWorkType.dataset.id;
      dispSum();
    });

    landRegions[land.dataset.id].addListener("mouseover", function(arg) {
      const land = document.getElementById("land_" + this.landId);
      document.getElementById("land_info").innerText = `${land.dataset.place}(${land.dataset.owner}):${land.dataset.area}a`;
    });

    landRegions[land.dataset.id].addListener("mouseout", function(arg) {
      document.getElementById("land_info").innerText = "";
    });
  });

  dispSum();
}

function clickWorkType(workTypeId) {
  selectedWorkType = document.getElementById("work_type_" + workTypeId);
  const workTypeName = document.getElementById("work_type_name");
  workTypeName.style.backgroundColor = selectedWorkType.dataset.bgColor;
  workTypeName.style.color = selectedWorkType.dataset.fgColor;
  workTypeName.innerText = selectedWorkType.value;
}

function dispSum() {
  const landAreas = {};
  Array.from(document.getElementById("lands").getElementsByTagName("input")).forEach(function(land) {
    if(land.value != "") {
      landAreas[land.value] = new Decimal(landAreas[land.value] || 0);
      landAreas[land.value] = landAreas[land.value].plus(land.dataset.area);
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

  document.getElementById("land_area_sum").innerText = sumArea.toFixed(1);
}

document.addEventListener('turbo:load', () => {
    Array.from(document.getElementsByClassName("work-type")).forEach(function(wt) {
        wt.addEventListener('click', function() {
            clickWorkType(this.dataset.id);
        });
    });
    initMap();
});
