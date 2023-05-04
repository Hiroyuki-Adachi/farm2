import { Turbo } from "@hotwired/turbo-rails"

window.addEventListener('turbo:load', () => {
    window.chemicalClick = (target) => {
        fetch(target.dataset.url, {
            "Accept": "text/vnd.turbo-stream.html",
            method: 'GET'
        })
        .then(res => res.text())
        .then(html => Turbo.renderStreamMessage(html));
    };
});
