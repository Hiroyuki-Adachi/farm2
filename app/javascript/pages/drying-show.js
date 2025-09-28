import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
    document.querySelectorAll("#drying-detail td").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.dataset.drying);
        });
    });
};
