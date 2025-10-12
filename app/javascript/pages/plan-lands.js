import { Decimal } from "decimal.js";

await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

let selectedWorkType;

const initMap = () => {
  const org = JSON.parse(document.getElementById("location").value);
  const pos = {lat: org[0], lng: org[1]};
  const DEFAULT_COLOR = "#000000";

  const map = new google.maps.Map(document.getElementById('map'), {
    mapId: 'FARM2_MAP',
    center: pos,
    zoom: 16
  });

  const marker = new google.maps.marker.AdvancedMarkerElement({
    position: pos,
    title: document.getElementById("organization_name").value,
    map: map
  });

  const workTypes = {};
  Array.from(document.getElementById("work_types").getElementsByTagName("input")).forEach((workType) => {
    workTypes[workType.dataset.id] = workType.dataset.bgColor;
  });

  const landRegions = {};
  Array.from(document.getElementById("lands").getElementsByTagName("input")).forEach((land) => {
    const paths = [];
    JSON.parse(land.dataset.region.replace(/\(/g, "[").replace(/\)/g, "]")).forEach((rg) => {
      paths.push({ lat: rg[0], lng: rg[1] });
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

    landRegions[land.dataset.id].addListener("click", function () {
      this.setOptions({
        strokeColor: selectedWorkType.dataset.bgColor,
        fillColor: selectedWorkType.dataset.bgColor
      });
      document.getElementById("land_" + this.landId).value = selectedWorkType.dataset.id;
      dispSum();
    });

    landRegions[land.dataset.id].addListener('rightclick', function () {
      this.setOptions({
        strokeColor: DEFAULT_COLOR,
        fillColor: DEFAULT_COLOR,
      });
      document.getElementById(`land_${this.landId}`).value = "";
      dispSum();
    });

    landRegions[land.dataset.id].addListener("mouseover", function () {
      const land = document.getElementById(`land_${this.landId}`);
      document.getElementById("land_info").innerText = `${land.dataset.place}(${land.dataset.owner}):${land.dataset.area}a`;
    });

    landRegions[land.dataset.id].addListener("mouseout", function () {
      document.getElementById("land_info").innerText = "";
    });
  });

  dispSum();
}

const clickWorkType = (workTypeId) => {
  selectedWorkType = document.getElementById(`work_type_${workTypeId}`);
  const workTypeName = document.getElementById("work_type_name");
  workTypeName.style.backgroundColor = selectedWorkType.dataset.bgColor;
  workTypeName.style.color = selectedWorkType.dataset.fgColor;
  workTypeName.innerText = selectedWorkType.value;
}

const dispSum = () => {
  const landAreas = {};
  Array.from(document.getElementById("lands").getElementsByTagName("input")).forEach(function (land) {
    if (land.value != "") {
      landAreas[land.value] = new Decimal(landAreas[land.value] || 0);
      landAreas[land.value] = landAreas[land.value].plus(land.dataset.area);
    }
  });
  let sumArea = new Decimal(0);
  Object.keys(landAreas).forEach(function (key) {
    const landArea = document.getElementById(`land_area_${key}`);
    if (landArea != null) {
      landArea.innerText = landAreas[key].toFixed(1);
      sumArea = sumArea.plus(landAreas[key]);
    }
  });

  document.getElementById("land_area_sum").innerText = sumArea.toFixed(1);
}

const loadEvent = () => {
  Array.from(document.getElementsByClassName("work-type")).forEach(function (wt) {
    wt.addEventListener('click', function () {
      clickWorkType(this.dataset.id);
    });
  });
  initMap();
}

export const init = () => {
  loadEvent();
}
