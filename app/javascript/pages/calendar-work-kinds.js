export const init = () => {
    document.querySelectorAll("input[type='color']").forEach((element) => {
        element.addEventListener("change", (event) => {
            const id = `work_kind_id_${event.target.dataset.kind}`;
            document.getElementById(id).checked = true;
            document.querySelector(`label[for="${id}"]`).style.color = event.target.value;
        });
    });

    document.querySelectorAll("[id^='work_kind_id'").forEach((element) => {
        element.addEventListener("change", (event) => {
            if (!event.target.checked) {
                document.querySelector(`label[for="${event.target.id}"]`).style.color = "";
                document.getElementById(`text_color_${event.target.dataset.kind}`).value = "";
            }
        });
    });

    document.querySelectorAll("input[type='color']").forEach((element) => {
        document.querySelector(`label[for="work_kind_id_${element.dataset.kind}"]`).style.color = element.value;
    });
};
