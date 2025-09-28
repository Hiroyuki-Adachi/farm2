import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

window.addEventListener('turbo:load', () => {
    document.getElementById("term").addEventListener("change", (event) => {
        fetch(`${document.getElementById("work_types_works_path").value}?term=${event.target.value}`, {
            "Accept": "text/vnd.turbo-stream.html",
            method: 'GET'
        })
        .then(res => res.text())
        .then(html => Turbo.renderStreamMessage(html));
    });

    document.getElementById("work_type_id").addEventListener("change", (event) => {
        fetch(`${document.getElementById("work_kinds_works_path").value}?work_type_id=${event.target.value}`, {
            "Accept": "text/vnd.turbo-stream.html",
            method: 'GET'
        })
        .then(res => res.text())
        .then(html => Turbo.renderStreamMessage(html));
    });

    window.showWork = function(tr) {
        Turbo.visit(tr.dataset.url);
    }
});

export default class extends Controller {}
