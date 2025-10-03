import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
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

    document.querySelectorAll('input[name="schedule[farming_flag]"]').forEach((option) => {
        option.addEventListener("change", () => {
            changeVisible(option.value);
        });
    });

    changeVisible(document.querySelector('input[name="schedule[farming_flag]"]:checked').value);
};

const changeVisible = (value) => {
    document.querySelectorAll('.farming-visible').forEach((element) => {
        if (value === "true") {
            element.style.display = "block";
        } else {
            element.style.display = "none";
        }
    });
}