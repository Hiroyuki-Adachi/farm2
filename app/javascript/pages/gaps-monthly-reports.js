import { Turbo } from "@hotwired/turbo-rails";

document.addEventListener('turbo:load', () => {
    document.getElementById("work_type_id").addEventListener("change", (event) => {
        Turbo.visit(document.getElementById("monthly_report_path").value.replace(":work_type_id", event.target.value));
    });
    document.getElementById("worked_at").addEventListener("change", () => {
        document.getElementById("search_form").requestSubmit();
    });
});
