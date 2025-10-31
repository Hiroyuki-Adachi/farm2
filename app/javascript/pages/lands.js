import "bootstrap";
import { TerraDraw, TerraDrawPolygonMode, TerraDrawSelectMode } from "terra-draw";
import { TerraDrawGoogleMapsAdapter } from "terra-draw-google-maps-adapter";

let landRegion;
let draw = null;

async function initMap(){
  await google.maps.importLibrary("drawing");
  const org = JSON.parse(document.getElementById("location").value);
  const pos = {lat: org[0], lng: org[1]};

  const map = new google.maps.Map(document.getElementById('map'), {
    center: pos,
    zoom: 18,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  });

  landRegion = new google.maps.Polygon({
    paths: convertRegion(document.getElementById("land_region").value),
    strokeColor: "#FF0000",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#FF0000",
    fillOpacity: 0.35,
    map: map
  });

  const otherRegions = []
  document.getElementsByName("other_lands").forEach(function(other) {
    otherRegions.push(new google.maps.Polygon({
        paths: convertRegion(other.value),
        strokeColor: "#ffffff",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#ffffff",
        fillOpacity: 0.35,
        map: map
    }));
  });

  map.addListener("projection_changed", () => {
    polygon = new TerraDrawPolygonMode({
      editable: true,
      styles: (() => {
        return {
            fillColor: '#99ff99',
            outlineColor: '#99ff99',
        };
      })(),
    });
    draw = new TerraDraw({
      adapter: new TerraDrawGoogleMapsAdapter({ map, lib: google.maps }),
      modes: [
        new TerraDrawPolygonMode({
          editable: true,
          styles: (() => {
            return {
                fillColor: '#99ff99',
                outlineColor: '#99ff99',
            };
          })(),
        }),
        new TerraDrawSelectMode({
          flags: {
            polygon: {
              feature: {
                draggable: true,
                rotateable: true,
                coordinates: {
                  midpoints: true,
                  draggable: true,
                  deletable: true,
                },
              },
            }
          }
        })
      ]
    });

    draw.start();

    draw.on('ready', () => {
      draw.setMode('polygon');
    });

  });
}

function convertRegion(region) {
  if(region == "") {
    return [];
  }

  const results = [];
  JSON.parse(region.replace(/\(/g, "[").replace(/\)/g, "]")).forEach(function(rg) {
    results.push({lat: rg[0], lng: rg[1]});
  });
  return results;
}

export const init = () => {
  document.getElementById("clear_region").addEventListener("click", function() {
    if(landRegion) {
      landRegion.setMap(null);
      document.getElementById("land_region").value = "";
      landRegion = null;
    }
    draw.clear();
  });

  let popForm = null;
  document.querySelectorAll(".edit-homes").forEach((element) => {
    element.addEventListener("click", (event) => {
      popForm = new bootstrap.Modal(document.getElementById("popup_edit"));
      document.getElementById("destroy_path").value = event.target.dataset.updatePath;
      document.getElementById("index_path").value = event.target.dataset.path;
      popupModal(event.target.dataset.path, () => {
        popForm.show();
        popForm._isTransitioning= false;
      });
    });
  });

  document.getElementById("popup_update").addEventListener("click", () => {
    fetch(document.getElementById("index_path").value, {
      method: "POST",
      body: new FormData(document.getElementById("update_form"))
    })
    .then(() => {
      popupModal(document.getElementById("index_path").value)
    });

  });
  document.getElementById("popup_close").addEventListener("click", () => {
    popForm.hide();
  });
  document.getElementById("popup_delete").addEventListener("click", () => {
    popupConfirm("表示中のデータを削除してもよろしいですか？", (result) => {
      if (result) {
        popForm.hide();
      }
    });
  });
  initMap();
};

function popupModal(action, callback) {
  fetch(action)
  .then((data) => data.text())
  .then((html) => {
      document.getElementById("popup_content").innerHTML = html;

      if (callback) {
        callback();
      }
  });
}
