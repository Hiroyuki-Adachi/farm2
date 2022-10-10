window.addEventListener('turbo:load', () => {
    $(window).on("resize", function() {
        initSize();
    });
    document.querySelectorAll(".check-weather").forEach((element) => {
        element.addEventListener("change", (event) => {
            checkWeather(event.target);
        });
    });

    initSize();
    checkWeather(document.getElementById("check_temprature"));
    checkWeather(document.getElementById("check_water"));
    checkWeather(document.getElementById("check_wind"));
    checkWeather(document.getElementById("check_other"));
});

function initSize() {
    const wrapper = document.getElementById("calendar-wrapper");

    wrapper.style.height = window.innerHeight - wrapper.offsetTop - document.getElementById("btn_toolbar").offsetHeight + "px";
}

function checkWeather(checkbox) {
    document.querySelectorAll(checkbox.dataset.css).forEach((element) => {
        element.style.display = checkbox.checked ? "block" : "none";
    });
}
