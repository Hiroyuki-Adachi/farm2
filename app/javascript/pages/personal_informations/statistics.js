import Chart from "chart.js/auto";

export const init = () => {
  const ctx1 = document.getElementById("chart1").getContext('2d');
  const ctx2 = document.getElementById("chart2").getContext('2d');
  const chart1 = new Chart(ctx1, {
    type: 'bar',
    data: {
      labels: JSON.parse(document.getElementById("chart1_labels").value),
      datasets: [{
        label: "本人",
        data: JSON.parse(document.getElementById("chart1_data1").value),
        backgroundColor: 'rgba(99, 200, 132, 1.0)',
        fill: false
      }, {
        label: "世帯",
        data: JSON.parse(document.getElementById("chart1_data2").value),
        backgroundColor: 'rgba(192, 192, 192, 1.0)',
        fill: false
      }]
    },
    options: {
      title: {
        display: true,
        text: '作業時間(年間推移)'
      },
      scales: {
        x: {
          stacked: true
        },
        y: {
          stacked: true,
          ticks: {
              beginAtZero: true,
              min: 0
          }            
        }
      }
    }
  });

  const chart2 = new Chart(ctx2, {
    type: 'bar',
    data: {
      labels: [1,2,3,4,5,6,7,8,9,10,11,12],
      datasets: [{
        label: "前年度",
        data: JSON.parse(document.getElementById("chart2_data1").value),
        backgroundColor: 'rgba(192, 192, 192, 1.0)',
        fill: true
      }, {
        label: "今年度",
        data: JSON.parse(document.getElementById("chart2_data2").value),
        backgroundColor: 'rgba(99, 200, 132, 1.0)',
        fill: true
      }]
    },
    options: {
      title: {
        display: true,
        text: '作業時間(前年同月比)'
      }
    }
  });
};
