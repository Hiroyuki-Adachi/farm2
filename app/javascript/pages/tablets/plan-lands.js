import { Decimal } from "decimal.js";

await google.maps.importLibrary("marker");

const DEFAULT_COLOR = "#000000";
let selectedWorkTypeId = "";
let selectedColor = DEFAULT_COLOR;
let landLabels = [];
let landLabelsVisible = true;

function parsePoint(value) {
  if (!value) return null;

  const matches = value.match(/-?\d+(?:\.\d+)?/g);
  if (!matches || matches.length < 2) return null;

  return { lat: Number(matches[0]), lng: Number(matches[1]) };
}

function parsePolygon(value) {
  if (!value) return [];

  const matches = value.match(/\((-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\)/g) || [];
  return matches.map((pair) => {
    const numbers = pair.match(/-?\d+(?:\.\d+)?/g) || [];
    return { lat: Number(numbers[0]), lng: Number(numbers[1]) };
  }).filter((point) => !Number.isNaN(point.lat) && !Number.isNaN(point.lng));
}

function workTypeColors() {
  return Array.from(document.querySelectorAll(".work-type")).reduce((colors, button) => {
    colors[button.dataset.workTypeId] = button.dataset.bgColor;
    return colors;
  }, {});
}

function selectWorkType(button) {
  document.querySelectorAll(".work-type").forEach((target) => {
    target.classList.toggle("border", target === button);
    target.classList.toggle("border-primary", target === button);
    target.classList.toggle("border-4", target === button);
    target.setAttribute("aria-pressed", target === button ? "true" : "false");
  });
  selectedWorkTypeId = button.dataset.workTypeId;
  selectedColor = button.dataset.bgColor;
}

function updateAreaSums() {
  const sums = {};
  let total = new Decimal(0);

  document.querySelectorAll("#lands input").forEach((land) => {
    if (!land.value) return;

    sums[land.value] = (sums[land.value] || new Decimal(0)).plus(land.dataset.area || 0);
    total = total.plus(land.dataset.area || 0);
  });

  document.querySelectorAll('[id^="land_area_"]').forEach((element) => {
    const workTypeId = element.id.replace("land_area_", "");
    element.textContent = (sums[workTypeId] || new Decimal(0)).toFixed(1);
  });
  document.getElementById("land_area_sum").textContent = total.toFixed(1);
}

function wireLandLabelToggle() {
  const button = document.getElementById("toggle_land_labels");
  button.onclick = () => {
    landLabelsVisible = !landLabelsVisible;
    landLabels.forEach((label) => { label.hidden = !landLabelsVisible; });
    button.setAttribute("aria-pressed", landLabelsVisible ? "true" : "false");
    button.textContent = landLabelsVisible ? "地番・面積を隠す" : "地番・面積を表示";
  };
}

function initMap() {
  const org = parsePoint(document.getElementById("location")?.value) || { lat: 35.0, lng: 135.0 };
  const colors = workTypeColors();
  const map = new google.maps.Map(document.getElementById("map"), {
    center: org,
    zoom: 16,
    gestureHandling: "greedy",
    fullscreenControl: false,
    mapId: "FARM2_MAP"
  });
  document.getElementById("map").style.setProperty("touch-action", "none", "important");

  new google.maps.marker.AdvancedMarkerElement({
    position: org,
    title: document.getElementById("organization_name")?.value,
    map: map
  });

  document.querySelectorAll("#lands input").forEach((land) => {
    const paths = parsePolygon(land.dataset.region);
    if (paths.length === 0) return;

    const color = colors[land.value] || DEFAULT_COLOR;
    const polygon = new google.maps.Polygon({
      paths: paths,
      strokeColor: color,
      strokeOpacity: 0.85,
      strokeWeight: 2,
      fillColor: color,
      fillOpacity: 0.45,
      map: map
    });

    polygon.addListener("click", () => {
      land.value = selectedWorkTypeId;
      polygon.setOptions({ strokeColor: selectedColor, fillColor: selectedColor });
      updateAreaSums();
    });

    const center = parsePoint(land.dataset.center);
    if (!center) return;

    const label = document.createElement("div");
    label.className = "map-label";
    label.textContent = `${land.dataset.place}(${land.dataset.area}a)`;
    landLabels.push(label);
    new google.maps.marker.AdvancedMarkerElement({ position: center, map: map, content: label });
  });

  updateAreaSums();
}

export const init = () => {
  landLabels = [];
  landLabelsVisible = true;
  const buttons = document.querySelectorAll(".work-type");
  buttons.forEach((button) => button.addEventListener("click", () => selectWorkType(button)));
  if (buttons.length > 0) selectWorkType(buttons[0]);
  wireLandLabelToggle();
  initMap();
};
