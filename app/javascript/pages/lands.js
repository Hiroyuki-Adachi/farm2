import "bootstrap";
import { TerraDraw, TerraDrawPolygonMode } from "terra-draw";
import { TerraDrawGoogleMapsAdapter } from "terra-draw-google-maps-adapter";

let landRegion = null;
let draw = null;

async function initMap(){
  await google.maps.importLibrary("drawing");
  await google.maps.importLibrary("maps");
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
  document.getElementsByName("other_lands").forEach((other) => {
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
        })
      ]
    });

    draw.start();

    draw.on('ready', () => {
      // 初期描画済の場合は静的モード(編集不可)にする
      if (document.getElementById("land_region").value == "") {
        draw.setMode('polygon');
      } else {
        draw.setMode('static');
      }
    });

    draw.on('finish', () => {
      // 描画完了時、描画モードを静的モードに変更し、座標を設定
      draw.setMode('static');
      const features = draw.getSnapshot();
      const pgGeo = [];
      features[0].geometry.coordinates[0].slice(0, -1).forEach((geo) => {
        pgGeo.push(`(${geo[1]},${geo[0]})`);
      });
      document.getElementById("land_region").value = `(${pgGeo.join(",")})`;
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
    // クリアボタン押下時、地図上のポリゴンがあれば削除
    if(landRegion) {
      landRegion.setMap(null);
      document.getElementById("land_region").value = "";
    }
    // 描画中のポリゴンがあればクリアし、描画モードに変更
    draw.clear();
    draw.setMode('polygon');
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
