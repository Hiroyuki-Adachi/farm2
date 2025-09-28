import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
    document.querySelectorAll("input[type='radio'][id^='work_type']:checked").forEach((element) => {
        element.closest("tr").style.backgroundColor = element.dataset.bgColor;
        element.closest("tr").style.color = element.dataset.fgColor;
    });

    Array.from(document.getElementsByClassName("date-activated")).forEach((element) => {
        element.addEventListener("blur", (event) => {
            const work_type = document.querySelector(`input[name="${event.target.dataset.name}"]:checked`);
            if (work_type == null) {
                Turbo.visit(`${event.target.dataset.url}?date=${event.target.value}&index=${event.target.dataset.index}`);
            } else {
                Turbo.visit(`${event.target.dataset.url}?date=${event.target.value}&index=${event.target.dataset.index}&work_type_id=${work_type.value}`);
            }
        });
    });
};

window.selectWorktype = (element) => {
    element.closest("tr").style.backgroundColor = element.dataset.bgColor;
    element.closest("tr").style.color = element.dataset.fgColor;
};
