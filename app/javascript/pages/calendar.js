export const init = () => {
    document.querySelectorAll(".check-weather").forEach((element) => {
        element.addEventListener("change", (event) => {
            checkWeather(event.target);
        });
    });

    checkWeather(document.getElementById("check_temprature"));
    checkWeather(document.getElementById("check_water"));
    checkWeather(document.getElementById("check_wind"));
    checkWeather(document.getElementById("check_other"));
};

const checkWeather = (checkbox) => {
    document.querySelectorAll(checkbox.dataset.css).forEach((element) => {
        element.style.display = checkbox.checked ? "block" : "none";
    });
}
