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
  const pos = parsePoint(document.getElementById("location")?.value) || { lat: 35.0, lng: 135.0 };

  const map = new google.maps.Map(document.getElementById("map"), {
    center: pos,
    zoom: 16,
    mapId: "FARM2_MAP"
  });

  new google.maps.marker.AdvancedMarkerElement({
    position: pos,
    title: document.getElementById("organization_name")?.value,
    map: map
  });

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

    polygon.addListener("mouseover", function() {
      const currentLand = document.getElementById(`land_${this.landId}`);
      if (!currentLand) {
        return;
      }
      document.getElementById("land_info").innerText = `${currentLand.dataset.place}(${currentLand.dataset.owner}):${currentLand.dataset.area}a 使用${currentLand.dataset.actual} 規定${currentLand.dataset.standard}`;
    });

    polygon.addListener("mouseout", function() {
      document.getElementById("land_info").innerHTML = "&nbsp;";
    });
  });
}

export const init = () => {
  initMap();
};
