import Chart from "chart.js/auto";

export const init = () => {
  const canvas = document.getElementById("chart");
  if (!canvas) return;

  const labels = JSON.parse(canvas.dataset.labels || "[]");
  const values = JSON.parse(canvas.dataset.values || "[]");
  const title = canvas.dataset.title || "作業効率";
  canvas.dataset.chartRendered = "0";

  const existingChart = Chart.getChart(canvas);
  if (existingChart) existingChart.destroy();

  const chart = new Chart(canvas.getContext("2d"), {
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
};
