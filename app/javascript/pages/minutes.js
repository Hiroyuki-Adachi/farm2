export const init = () => {
    document.getElementById("minute_pdf").addEventListener("change", (event) => {
        event.target.closest("form").requestSubmit();
    });

    document.querySelectorAll(".create-pdf").forEach((element) => {
        element.addEventListener("click", (event) => {
            document.getElementById("minute_schedule_id").value = event.target.dataset.schedule;
            document.getElementById("minute_pdf").click();
        });
    })
};
