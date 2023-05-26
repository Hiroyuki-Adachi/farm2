import { Turbo } from "@hotwired/turbo-rails";

window.addEventListener('turbo:load', () => {
    document.querySelectorAll('input[name="schedule[work_type_id]"]').forEach((element) => {
        element.addEventListener("change", (event) => {
            fetch(`${document.getElementById("work_kinds_works_path").value}?work_type_id=${event.target.value}`, {
                "Accept": "text/vnd.turbo-stream.html",
                method: 'GET'
            })
            .then(res => res.text())
            .then(html => Turbo.renderStreamMessage(html));
        });
    });
});
