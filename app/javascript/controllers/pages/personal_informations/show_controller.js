import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";

window.addEventListener('turbo:load', () => {
    document.querySelectorAll("#personal_table tr").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.closest("tr").dataset.href);
        });
    });
});

export default class extends Controller {}
