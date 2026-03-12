import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
    document.getElementById("home").addEventListener("change", (event) => {
        if(event.target.value == "") {
            Turbo.visit(document.getElementById("lands_path").value);
        } else {
            Turbo.visit(`${document.getElementById("lands_path").value}?home_id=${event.target.value}`);
        }
    });
};
