import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";

window.addEventListener('turbo:load', () => {
    document.querySelectorAll("#drying-detail td").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.dataset.drying);
        });
    });
});

export default class extends Controller {}
