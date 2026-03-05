await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

function initMap() {
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
    JSON.parse(land.value.replace(/\(/g, "[").replace(/\)/g, "]")).forEach((rg) => {
      paths.push({ lat: rg[0], lng: rg[1] });
    });

    new google.maps.Polygon({
      paths: paths,
      strokeColor: "#000000",
      strokeOpacity: 0.9,
      strokeWeight: 2,
      fillColor: "#000000",
      fillOpacity: 0.2,
      map: map
    });
  });
}

export const init = () => {
  initMap();
};
