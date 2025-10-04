import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
    document.querySelectorAll("#personal_table tr").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.closest("tr").dataset.href);
        });
    });
};
