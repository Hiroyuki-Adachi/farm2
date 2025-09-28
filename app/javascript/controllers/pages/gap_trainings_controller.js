import { Controller } from "@hotwired/stimulus"
document.addEventListener('turbo:load', () => {
    document.getElementById("study").addEventListener("change", (event) => {
        document.querySelectorAll(".studies").forEach((element) => {
            element.disabled = !event.target.checked;
        });
    });
});

export default class extends Controller {}
