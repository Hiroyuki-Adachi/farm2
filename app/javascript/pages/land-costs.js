import { Turbo } from "@hotwired/turbo-rails";

let colors = null;
export const init = () => {
    colors = JSON.parse(document.getElementById("colors").value);
    allWorkTypesSelect();

    document.querySelectorAll("input[type='radio'][id^='land_place']").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.dataset.url);
            allWorkTypesSelect();
        });
    });

    document.querySelectorAll("input[type='radio'][id^='work_type']").forEach((element) => {
        element.addEventListener("click", (event) => {
            if (event.target.checked) {
                event.target.closest("tr").style.backgroundColor = colors[element.value].bg;
                event.target.closest("tr").style.color = colors[element.value].fg;
            }
        });
    });
};

const allWorkTypesSelect = () => {
    document.querySelectorAll("input[type='radio'][id^='work_type']:checked").forEach((element) => {
        element.closest("tr").style.backgroundColor = colors[element.value].bg;
        element.closest("tr").style.color = colors[element.value].fg;
    });
}
