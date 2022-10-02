window.addEventListener('turbo:load', () => {
    document.getElementById("term").addEventListener("change", (event) => {
        Turbo.visit(`${document.getElementById("work_types_works_path").value}?term=${event.target.value}`);
    });

    document.getElementById("work_type_id").addEventListener("change", (event) => {
        Turbo.visit(`${document.getElementById("work_kinds_works_path").value}?work_type_id=${event.target.value}`);
    });

    Turbo.visit(`${document.getElementById("work_types_works_path").value}?term=${document.getElementById("term").value}&work_type_id=${document.getElementById("work_type_id").value}`);
    Turbo.visit(`${document.getElementById("work_kinds_works_path").value}?work_kind_id=${document.getElementById("work_kind_id").value}`);
});

window.showWork = function(tr) {
    Turbo.visit(tr.dataset.url);
}
