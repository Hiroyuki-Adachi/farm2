import Chart from "chart.js/auto";

export const init = () => {
  const form = document.querySelector("[data-statistics-areas-target='form']");
  const canvas = document.getElementById("chart");
  if (!canvas) return;

  const labels = JSON.parse(canvas.dataset.labels || "[]");
  const values = JSON.parse(canvas.dataset.values || "[]");
  const title = canvas.dataset.title || "作業効率";
  canvas.dataset.chartRendered = "0";

  let currentAbort = null;
  let activeKey = null;

  const existingChart = Chart.getChart(canvas);
  const chart = existingChart || new Chart(canvas.getContext("2d"), {
    type: "bar",
    data: {
      labels,
      datasets: [
        {
          label: `${title} 10aあたり時間`,
          data: values,
          backgroundColor: "rgba(99, 200, 132, 0.8)",
          fill: false
        }
      ]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: "時間"
          }
        }
      }
    }
  });

  chart.options.animation.onComplete = () => {
    canvas.dataset.chartRendered = "1";
  };
  requestAnimationFrame(() => chart.resize());

  const updateChart = async (input) => {
    canvas.dataset.chartRendered = "0";

    if (currentAbort) currentAbort.abort();
    currentAbort = new AbortController();
    const thisKey = (activeKey = Symbol("statisticsAreasFetch"));
    const url = new URL(form.action, window.location.href);
    url.searchParams.set(input.name, input.value);

    try {
      canvas.setAttribute("data-loading", "1");

      const res = await fetch(url, {
        signal: currentAbort.signal,
        cache: "no-store",
        headers: { Accept: "application/json" }
      });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      const json = await res.json();
      if (thisKey !== activeKey) return;

      chart.data.labels = json.labels;
      chart.data.datasets[0].label = `${json.title || "作業効率"} 10aあたり時間`;
      chart.data.datasets[0].data = json.values;
      chart.update();

      window.history.replaceState(null, "", url);
    } catch (err) {
      if (err.name !== "AbortError") {
        console.error("[statistics-areas] fetch/render error:", err);
        window.popupAlert?.(`グラフの描画に失敗しました(${err.message})`);
      }
    } finally {
      if (thisKey === activeKey) {
        canvas.removeAttribute("data-loading");
      }
    }
  };

  if (!form || form.dataset.statisticsAreasBound === "1") return;
  form.dataset.statisticsAreasBound = "1";

  form.addEventListener("change", async (event) => {
    const input = event.target.closest("input[name='work_kind_id']");
    if (!input || !input.checked) return;

    event.preventDefault();
    await updateChart(input);
  });

  form?.addEventListener("submit", async (event) => {
    const input = form.querySelector("input[name='work_kind_id']:checked");
    if (!input) return;

    event.preventDefault();
    await updateChart(input);
  });
};
