// pages/work-lands.js
import AutoComplete from "@tarekraafat/autocomplete.js";
import Decimal from "decimal.js";
import Sortable from "sortablejs";

const state = {
  lands: [], // { id, place, owner, area }  ※areaはDecimal化せず生の数値/文字列で保持
};

const els = {};

function q(sel) { return document.querySelector(sel); }
function qa(sel) { return Array.from(document.querySelectorAll(sel)); }

function asDecimal(v) {
  // "12.30" などを Decimal に安全変換
  return new Decimal(String(v || 0).replace(/,/g, ""));
}

function render() {
  // tbody を再構築（DocumentFragmentで一括差替え）
  const frag = document.createDocumentFragment();

  state.lands.forEach((land, idx) => {
    const tr = document.createElement("tr");
    tr.id = `land_${land.id}`;
    tr.dataset.landId = land.id;
    tr.innerHTML = `
      <td class="numeric w-10">${idx + 1}</td>
      <td class="w-60">${land.place}(${land.owner})</td>
      <td class="numeric w-30">${Number(land.area).toFixed(2)}</td>
      <td class="w-20">
        <button type="button" class="btn btn-outline-dark btn-sm js-remove" aria-label="削除">削除</button>
        <input type="hidden" name="work_lands[][land_id]" value="${land.id}">
        <input type="hidden" name="work_lands[][display_order]" value="${idx + 1}">
      </td>
    `;
    frag.appendChild(tr);
  });

  els.tbody.replaceChildren(frag);

  // 合計
  const total = state.lands.reduce((acc, l) => acc.plus(asDecimal(l.area)), new Decimal(0));
  els.totalArea.textContent = total.toFixed(2);
}

function addLand(land) {
  // 既存チェック
  if (state.lands.some(l => String(l.id) === String(land.id))) {
    window.popupAlert?.(`既に存在しています(${land.place})`);
    els.input.value = "";
    return;
  }
  state.lands.push(land);
  render();
  els.input.value = "";
}

function removeById(id) {
  const i = state.lands.findIndex(l => String(l.id) === String(id));
  if (i >= 0) {
    state.lands.splice(i, 1);
    render();
  }
}

function captureInitialRows() {
  // 初期サーバ描画分を state へ吸い上げ
  state.lands = qa("#tbody_lands tr[id^='land_']").map(tr => {
    const tds = tr.querySelectorAll("td");
    const hidden = tr.querySelectorAll("input[type='hidden']");
    const landId = tr.id.replace("land_", "");
    const placeText = tds[1]?.textContent?.trim() || "";
    const m = placeText.match(/^(.+)\(([^()]+)\)$/); // "地番(所有者)" の分離
    const place = m ? m[1] : placeText;
    const owner = m ? m[2] : "";
    const area = tds[2]?.textContent?.trim() || "0";
    return { id: landId, place, owner, area };
  });
  render();
}

function initSortable() {
  Sortable.create(els.tbody, {
    handle: undefined, // 必要ならドラッグハンドルを指定
    animation: 150,
    onSort() {
      // 並べ替え後の順序を state に反映
      const ids = qa("#tbody_lands tr").map(tr => tr.dataset.landId);
      state.lands.sort((a, b) => ids.indexOf(String(a.id)) - ids.indexOf(String(b.id)));
      render();
    },
  });
}

function initRemoveDelegation() {
  // 削除はイベント委譲
  els.tbody.addEventListener("click", (e) => {
    const btn = e.target.closest(".js-remove");
    if (!btn) return;
    const tr = btn.closest("tr");
    if (tr?.dataset.landId) removeById(tr.dataset.landId);
  });
}

async function initAutoComplete() {
  // preload=false でも安定するよう「準備完了フラグ」を立てる
  const acDataUrl = els.autocompletePath.value;

  const ac = new AutoComplete({
    data: {
      src: fetch(acDataUrl).then(r => r.json()),
      keys: ["place", "area"],
      cache: true,
    },
    selector: "#land",
    threshold: 2,
    resultsList: { maxResults: 20 },
    resultItem: {
      element: (item, data) => {
        item.innerHTML = `${data.value.place}(${data.value.owner})(${data.value.area})`;
      },
      highlight: true,
    },
    events: {
      input: {
        selection: (event) => {
          const v = event.detail.selection.value;
          addLand({ id: v.id, place: v.place, owner: v.owner, area: v.area });
        },
      },
    },
  });

  // 初期化完了の印（system test で待てる）
  els.input.dataset.acReady = "1";
  return ac;
}

export const init = async () => {
  // 要素束ね
  els.tbody = q("#tbody_lands");
  els.totalArea = q("#total_area");
  els.input = q("#land");
  els.autocompletePath = q("#autocomplete_work_lands_path");

  captureInitialRows();
  initRemoveDelegation();
  initSortable();
  await initAutoComplete();
};
