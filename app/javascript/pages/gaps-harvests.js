import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
  const workTypeEl = document.getElementById("work_type_id");
  const workedAtEl = document.getElementById("worked_at");
  const monthsPathEl = document.getElementById("harvest_months_path");
  const formEl = document.getElementById("search_form");

  if (!workTypeEl || !workedAtEl || !monthsPathEl || !formEl) return;

  workTypeEl.addEventListener("change", (event) => {
    if (!event.target.value) return;
    Turbo.visit(monthsPathEl.value.replace(":work_type_id", event.target.value));
  });

  workedAtEl.addEventListener("change", () => {
    formEl.requestSubmit();
  });
};
