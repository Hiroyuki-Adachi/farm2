function calc_total()
{
    var total_hours = 0.0;
    var total_amount = 0;
    var total_machine = 0;
    var id;

    $("input[name^='fixed_works']:checked").each(function(i, e) {
        id = e.value;
        total_hours += parseFloat($("#hours_" + id).html());
        total_amount += parseInt($("#amount_" + id).html().replace(/,/g, ""));
        total_machine += parseInt($("#machine_" + id).html().replace(/,/g, ""));
    });

    $("#total_hours").html(total_hours.toFixed(1));
    $("#total_amount").html(insertComma(total_amount));
    $("#total_machine").html(insertComma(total_machine));
}

function insertComma(num)
{
    var dest = num.toString();
    var tmp;

    while(dest != (tmp = dest.replace(/^([+-]?\d+)(\d{3})/, "$1,$2"))) {
        dest = tmp;
    }
    return dest;
}

function checkAll(val)
{
    $("input[name^='fixed_works']").prop("checked", val);

    calc_total();
}

$(function() {
    $(".all-check").on('click', function() {
        checkAll(true);
    });
    $(".all-cancel").on('click', function() {
        checkAll(false);
    });
});
