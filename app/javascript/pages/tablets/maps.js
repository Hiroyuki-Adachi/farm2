import { Decimal } from "decimal.js";

await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

const DEFAULT_COLOR = "#000000";
const SELECTED_COLOR = "#f0ad00";
const polygons = [];
let selectedAreaEl;

function initMap() {
  polygons.length = 0;

  const org = JSON.parse(document.getElementById("location").value);
  const pos = { lat: org[0], lng: org[1] };

  const map = new google.maps.Map(document.getElementById("map"), {
    center: pos,
    zoom: 16,
    mapId: "FARM2_MAP"
  });

  new google.maps.marker.AdvancedMarkerElement({
    position: pos,
    title: document.getElementById("organization_name").value,
    map: map
  });

  document.getElementsByName("regions").forEach((land) => {
    if (!land.value) return;

    const paths = [];
    try {
      JSON.parse(land.value.replace(/\(/g, "[").replace(/\)/g, "]")).forEach((rg) => {
        paths.push({ lat: rg[0], lng: rg[1] });
      });
    } catch (_error) {
      return;
    }

    const polygon = new google.maps.Polygon({
      paths: paths,
      strokeColor: DEFAULT_COLOR,
      strokeOpacity: 0.9,
      strokeWeight: 2,
      fillColor: DEFAULT_COLOR,
      fillOpacity: 0.2,
      map: map
    });

    polygon.area = new Decimal(land.dataset.area || 0);
    polygon.selected = false;
    polygon.addListener("click", () => {
      polygon.selected = !polygon.selected;
      applyPolygonColor(polygon);
      updateSelectedArea();
    });

    polygons.push(polygon);
  });

  wireClearButton();
  updateSelectedArea();
}

function applyPolygonColor(polygon) {
  const color = polygon.selected ? SELECTED_COLOR : DEFAULT_COLOR;
  polygon.setOptions({
    strokeColor: color,
    fillColor: color
  });
}

function updateSelectedArea() {
  const area = polygons.reduce((sum, polygon) => {
    return polygon.selected ? sum.plus(polygon.area) : sum;
  }, new Decimal(0));

  selectedAreaEl.textContent = area.toFixed(1);
}

function wireClearButton() {
  const button = document.getElementById("clear_selection");
  button.onclick = () => {
    polygons.forEach((polygon) => {
      polygon.selected = false;
      applyPolygonColor(polygon);
    });
    updateSelectedArea();
  };
}

export const init = () => {
  selectedAreaEl = document.getElementById("selected_area_value");
  initMap();
};
