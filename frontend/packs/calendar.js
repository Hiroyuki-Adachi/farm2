import '../stylesheets/calendar';

$(function() {
    $(window).on("resize", function() {
        init_size();
    });
    $(".check-weather").change(function() {
        check_weather($(this));
    });

    init_size();
    check_weather($("#check_temprature"));
    check_weather($("#check_water"));
    check_weather($("#check_wind"));
    check_weather($("#check_other"));
});

function init_size() {
    const off = $("#calendar-wrapper").offset();

    $("#calendar-wrapper").height($(window).height() - off.top - $("#btn_toolbar").height());
    $("#calendar-wrapper").width($(window).width() - off.left);
}

function check_weather(checkbox) {
    if(checkbox.prop("checked")) {
        $(checkbox.data("css")).show();
    } else {
        $(checkbox.data("css")).hide();
    }
}
