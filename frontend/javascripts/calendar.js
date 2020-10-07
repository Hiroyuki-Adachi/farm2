$(function() {
    $(window).on("resize", function() {
        initSize();
    });
    $(".check-weather").change(function() {
        checkWeather($(this));
    });

    initSize();
    checkWeather($("#check_temprature"));
    checkWeather($("#check_water"));
    checkWeather($("#check_wind"));
    checkWeather($("#check_other"));
});

function initSize() {
    const off = $("#calendar-wrapper").offset();

    $("#calendar-wrapper").height($(window).height() - off.top - $("#btn_toolbar").height());
    $("#calendar-wrapper").width($(window).width() - off.left);
}

function checkWeather(checkbox) {
    if(checkbox.prop("checked")) {
        $(checkbox.data("css")).show();
    } else {
        $(checkbox.data("css")).hide();
    }
}
