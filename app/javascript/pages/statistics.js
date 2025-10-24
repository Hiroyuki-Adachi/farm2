import Chart from "chart.js/auto";

export const init = () => {
  const nav = document.querySelector(".nav"); // 親に委譲（なければ document でもOK）
  const canvas = document.getElementById("chart");
  if (!nav || !canvas) return;
  canvas.dataset.chartRendered = "0";

  let currentAbort = null;
  let activeKey = null; // レース対策用の「世代キー」

  // 既存チャートを安全に破棄
  const destroyChartIfAny = () => {
    const chart = Chart.getChart(canvas)
    if (chart) chart.destroy();
  };

  // クリックは親で委譲
  nav.addEventListener("click", async (e) => {
    canvas.dataset.chartRendered = "0";
    const link = e.target.closest(".nav-link");
    if (!link) return;

    // aタグなどなら遷移阻止
    if (link.tagName === "A") e.preventDefault();

    const url = link.dataset.url || link.dataset.action;
    if (!url) return;

    // 既にアクティブなら何もしない
    if (link.classList.contains("active")) return;

    // タブの active 切替（Bootstrap任せでなければ手動で）
    nav.querySelectorAll(".nav-link.active").forEach((el) => el.classList.remove("active"));
    link.classList.add("active");

    // 前回のリクエストを中断
    if (currentAbort) currentAbort.abort();
    currentAbort = new AbortController();
    const thisKey = (activeKey = Symbol("fetchKey"));

    try {
      // ローディング状態（必要なら）
      canvas.setAttribute("data-loading", "1");

      const res = await fetch(url, { signal: currentAbort.signal, cache: "no-store" });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const json = await res.json();

      // レース：古いレスポンスなら捨てる
      if (thisKey !== activeKey) return;

      // 既存チャートを破棄して描画
      destroyChartIfAny();
      const ctx = canvas.getContext("2d");
      const chart = new Chart(ctx, json);
      chart.options.animation.onComplete = () =>{
        // 描画完了時にフラグを立てる
        canvas.dataset.chartRendered = "1";
      }
      // レイアウト確定後にリサイズ（非表示→表示直後の0x0対策）
      requestAnimationFrame(() => chart.resize());
    } catch (err) {
      if (err.name !== "AbortError") {
        console.error("[chart] fetch/render error:", err);
        window.popupAlert?.(`グラフの描画に失敗しました(${err.message})`);
      }
    } finally {
      if (thisKey === activeKey) {
        canvas.removeAttribute("data-loading");
      }
    }
  });
};
