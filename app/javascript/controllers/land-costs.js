import { Turbo } from "@hotwired/turbo-rails";

let colors = null;
document.addEventListener('turbo:load', () => {
    colors = JSON.parse(document.getElementById("colors").value);
    allWorktypesSelect();

    document.querySelectorAll("input[type='radio'][id^='land_place']").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.dataset.url);
            allWorktypesSelect();
        });
    });
});

function allWorktypesSelect() {
    document.querySelectorAll("input[type='radio'][id^='work_type']:checked").forEach((element) => {
        element.closest("tr").style.backgroundColor = colors[element.value].bg;
        element.closest("tr").style.color = colors[element.value].fg;
    });
}

function worktypeSelect(element) {
    element.closest("tr").style.backgroundColor = colors[element.value].bg;
    element.closest("tr").style.color = colors[element.value].fg;
}

window.worktypeSelect = worktypeSelect;
