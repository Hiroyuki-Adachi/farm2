import { Decimal } from "decimal.js";

function calcTotal()
{
    let totalHours = new Decimal(0);
    let totalAmount = new Decimal(0);
    let totalMachine = new Decimal(0);

    document.querySelectorAll("input[name^='fixed_works']:checked").forEach((element) => {
        const id = element.value;
        totalHours      = totalHours.plus(new Decimal(document.getElementById(`hours_${id}`).innerHTML));
        totalAmount     = totalAmount.plus(new Decimal(document.getElementById(`amount_${id}`).innerHTML.replace(/,/g, "") ));
        totalMachine    = totalMachine.plus(new Decimal(document.getElementById(`machine_${id}`).innerHTML.replace(/,/g, "")));
    });

    document.getElementById("total_hours").innerHTML = totalHours.toFixed(1);
    document.getElementById("total_amount").innerHTML = insertComma(totalAmount);
    document.getElementById("total_machine").innerHTML = insertComma(totalMachine);
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
    document.querySelectorAll("input[name^='fixed_works']").forEach((element) => {
        element.checked = val;
    });

    calcTotal();
}

export const init = () => {
    document.querySelectorAll(".all-check").forEach((element) => {
        element.addEventListener("click", () => {
            checkAll(true);
        });
    });
    document.querySelectorAll(".all-cancel").forEach((element) => {
        element.addEventListener("click", () => {
            checkAll(false);
        });
    });
    document.querySelectorAll("input[name^='fixed_works']").forEach(element => {
        element.addEventListener("change", () => {
            calcTotal();
        });
    });
};
