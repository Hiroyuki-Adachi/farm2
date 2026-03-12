import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
    Array.from(document.getElementsByClassName("work_select")).forEach((element) => {
        element.addEventListener("change", (event) => {
            const index = event.target.dataset.index;
            if (event.target.value == "") {
                document.getElementById(`work_result_id_${index}`).innerHTML = "";
            } else {
                Turbo.visit(`${event.target.dataset.url}?index=${index}&work_id=${event.target.value}`);
            }
        });
    });
};

