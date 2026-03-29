await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

function parsePoint(value) {
  if (!value) {
    return null;
  }

  try {
    const parsed = JSON.parse(value);
    if (Array.isArray(parsed) && parsed.length >= 2) {
      return { lat: Number(parsed[0]), lng: Number(parsed[1]) };
    }
  } catch (_error) {
  }

  const matches = value.match(/-?\d+(?:\.\d+)?/g);
  if (!matches || matches.length < 2) {
    return null;
  }

  return { lat: Number(matches[0]), lng: Number(matches[1]) };
}

function parsePolygon(value) {
  if (!value) {
    return [];
  }

  const matches = value.match(/\((-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\)/g) || [];
  return matches.map((pair) => {
    const numbers = pair.match(/-?\d+(?:\.\d+)?/g) || [];
    return { lat: Number(numbers[0]), lng: Number(numbers[1]) };
  }).filter((point) => !Number.isNaN(point.lat) && !Number.isNaN(point.lng));
}

function initMap() {
  const org = parsePoint(document.getElementById("location")?.value) || { lat: 35.0, lng: 135.0 };

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

  document.querySelectorAll('[name="regions"]').forEach((land) => {
    const paths = parsePolygon(land.value);
    if (paths.length === 0) {
      return;
    }

    new google.maps.Polygon({
      paths: paths,
      strokeColor: land.dataset.color || "#ffffff",
      strokeOpacity: 0.85,
      strokeWeight: 2,
      fillColor: land.dataset.color || "#ffffff",
      fillOpacity: 0.45,
      map: map
    });

    const center = parsePoint(land.dataset.center);
    if (!center) {
      return;
    }

    const labelEl = document.createElement("div");
    labelEl.className = "map-label";
    labelEl.textContent = `${land.dataset.place}(${land.dataset.area}a)`;

    new google.maps.marker.AdvancedMarkerElement({
      position: center,
      map: map,
      content: labelEl,
      title: labelEl.textContent
    });
  });
}

export const init = () => {
  initMap();
};
