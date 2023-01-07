import Chart from "chart.js/auto";

window.addEventListener("turbo:load", () => {
    const sleep = (second) => new Promise(resolve => setTimeout(resolve, second * 1000));

    document.querySelectorAll(".nav-link").forEach((element) => {
        element.addEventListener("turbo:click", async (event) => {
            if (window.myChart) {
                window.myChart.clear();
                window.myChart.destroy();
            }

            document.querySelectorAll(".nav-link").forEach((tab) => {
                tab.classList.remove("active");
            });
            event.target.classList.add("active");
            await sleep(1);
            switch(parseInt(event.target.dataset.tab)) {
                case 1:
                    tab1();
                    break;
                case 2:
                    tab2();
                    break;
                case 3:
                    tab3();
                    break;
            }
        });
    });
});

function tab1() {
    window.myChart = new Chart(document.getElementById("chart").getContext("2d"), {
        type: "bar",
        data: {
            labels: JSON.parse(document.getElementById("tab1_labels").value),
            datasets: [{
                label: "作業時間",
                data: JSON.parse(document.getElementById("tab1_data").value),
                backgroundColor: document.getElementById("tab1_color").value,
                fill: false
            }]
        }
    });
}

function tab2() {
    window.myChart = new Chart(document.getElementById("chart").getContext('2d'), {
        type: 'bar',
        data: {
          labels: JSON.parse(document.getElementById("tab2_labels").value),
          datasets: JSON.parse(document.getElementById("tab2_datasets").value)
        },
        options: {
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
}

function tab3() {
    window.myChart = new Chart(document.getElementById("chart").getContext('2d'), {
        type: 'bar',
        data: {
          labels: JSON.parse(document.getElementById("tab3_labels").value),
          datasets: JSON.parse(document.getElementById("tab3_datasets").value)
        },
        options: {
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
}