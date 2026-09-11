await google.maps.importLibrary("marker");
await google.maps.importLibrary("maps");

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
  const pos = parsePoint(document.getElementById("location")?.value) || { lat: 35.0, lng: 135.0 };

  const mapElement = document.getElementById("map");
  const tablet = mapElement.dataset.tablet === "true";
  const map = new google.maps.Map(mapElement, {
    center: pos,
    zoom: 16,
    gestureHandling: tablet ? "greedy" : "auto",
    fullscreenControl: !tablet,
    mapId: "FARM2_MAP"
  });

  new google.maps.marker.AdvancedMarkerElement({
    position: pos,
    title: document.getElementById("organization_name")?.value,
    map: map
  });

  const landLabels = [];
  document.querySelectorAll('[name="regions"]').forEach((land) => {
    const paths = parsePolygon(land.value);
    if (paths.length === 0) {
      return;
    }

    const polygon = new google.maps.Polygon({
      paths: paths,
      strokeColor: land.dataset.color || "#ffffff",
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: land.dataset.color || "#ffffff",
      fillOpacity: 0.35,
      landId: land.dataset.id,
      map: map
    });

    const showLandInfo = function() {
      const currentLand = document.getElementById(`land_${this.landId}`);
      if (!currentLand) {
        return;
      }
      document.getElementById("land_info").innerText = `${currentLand.dataset.place}(${currentLand.dataset.owner}):${currentLand.dataset.area}a ロール数(10a当):${currentLand.dataset.rolls}`;
    };

    polygon.addListener("click", showLandInfo);
    polygon.addListener("mouseover", showLandInfo);

    polygon.addListener("mouseout", function() {
      if (tablet) return;
      document.getElementById("land_info").innerHTML = "&nbsp;";
    });

    if (tablet) {
      const center = parsePoint(land.dataset.center);
      if (center) {
        const label = document.createElement("div");
        label.className = "map-label";
        label.textContent = `${land.dataset.place}(${land.dataset.area}a)`;
        landLabels.push(label);
        new google.maps.marker.AdvancedMarkerElement({ position: center, map: map, content: label });
      }
    }
  });

  const toggle = document.getElementById("toggle_land_labels");
  if (tablet && toggle) {
    let labelsVisible = true;
    toggle.setAttribute("aria-pressed", "true");
    toggle.textContent = "地番・面積を隠す";
    toggle.onclick = () => {
      labelsVisible = !labelsVisible;
      landLabels.forEach((label) => { label.hidden = !labelsVisible; });
      toggle.setAttribute("aria-pressed", String(labelsVisible));
      toggle.textContent = labelsVisible ? "地番・面積を隠す" : "地番・面積を表示";
    };
  }
}

export const init = () => {
  initMap();
};
