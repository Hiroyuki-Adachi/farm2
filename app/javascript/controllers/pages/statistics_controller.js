import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto";

window.addEventListener("turbo:load", () => {
    document.querySelectorAll(".nav-link").forEach((element) => {
        element.addEventListener("click", (event) => {
            if (window.myChart) {
                window.myChart.clear();
                window.myChart.destroy();
            }

            document.querySelectorAll(".nav-link").forEach((tab) => {
                tab.classList.remove("active");
            });
            event.target.classList.add("active");
            fetch(event.target.dataset.action)
            .then((res) => {
                return res.json();
            })
            .then((json) => {
                console.log(json);
                window.myChart = new Chart(document.getElementById("chart").getContext("2d"), json);
            });
        });
    });
});

export default class extends Controller {}
