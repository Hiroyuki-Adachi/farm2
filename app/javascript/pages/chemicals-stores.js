export const init = () => {
    document.querySelectorAll(".chemical_types").forEach((element) => {
        element.addEventListener("change", event => {
            let options = [];
            document.querySelectorAll(`input[type="hidden"][data-chemical-type="${event.target.value}"]`).forEach((hidden) => {
                options.push(`<option value="${hidden.dataset.id}">${hidden.value}</option>`)
            });
            const chemical = document.querySelector(`select[data-index="${event.target.dataset.index}"].chemical`);
            chemical.innerHTML = options.join();
            chemical.options[0].selected = true;
        });
    });
};
