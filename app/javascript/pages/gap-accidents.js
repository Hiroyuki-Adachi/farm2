import { Turbo } from "@hotwired/turbo-rails";
await google.maps.importLibrary("marker");
await google.maps.importLibrary("drawing");

export const init = () => {
    initMap();

    if (document.getElementById("worked_at") != null) {
        document.getElementById("worked_at").addEventListener("blur", (event) => {
            fetch(document.getElementById("works_gaps_accident_path").value.replace(":worked_at", event.target.value), {
                "Accept": "text/vnd.turbo-stream.html",
                method: 'GET'
            })
            .then(res => res.text())
            .then(html => Turbo.renderStreamMessage(html));
        });
    }
    if (document.getElementById("accident_work_id") != null) {
        document.getElementById("accident_work_id").addEventListener("change", (event) => {
            if (event.target.value == "") {
                return;
            }
            fetch(document.getElementById("audiences_gaps_accident_path").value.replace(":work_id", event.target.value), {
                "Accept": "text/vnd.turbo-stream.html",
                method: 'GET'
            })
            .then(res => res.text())
            .then(html => Turbo.renderStreamMessage(html));
        });
    }
};

function initMap(){
    const location = document.getElementById("accident_location");
    if (location == null) {
        return;
    }
    const home = JSON.parse(location.value.replace("(", "[").replace(")", "]"));
    const pos = {lat: home[0], lng: home[1]};
  
    const map = new google.maps.Map(document.getElementById('map'), {
      center: pos,
      zoom: 16,
      mapId: 'FARM2_MAP'
    });

    const marker = new google.maps.marker.AdvancedMarkerElement({
      position: pos,
      gmpDraggable: true,
      map: map
    });

    marker.addListener("dragend", function(event) {
      location.value = `(${event.latLng.lat().toFixed(6)}, ${event.latLng.lng().toFixed(6)})`;
    });
}
