window.addEventListener("DOMContentLoaded", () => {
    document.getElementById("work_type_id").addEventListener("change", (event) => {
        document.getElementById("select_work_type_id").value = event.target.value;
        Rails.fire(document.getElementById("work_type_select_form"), "submit");
    });
});

window.showWork = function(tr) {
    location.href = tr.dataset.url;
}
