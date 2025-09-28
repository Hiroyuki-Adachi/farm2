export const init = () => {
    document.querySelectorAll(".drying-data").forEach((element) => {
        element.addEventListener("click", (event) => {
            document.getElementById("drying_home_id").value = element.dataset.home;
            document.getElementById("drying_carried_on").value = element.dataset.worked_at;
            document.getElementById("new_drying").requestSubmit();
        });
    });
};
