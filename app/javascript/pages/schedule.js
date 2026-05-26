export const init = () => {
    document.querySelectorAll('input[name="schedule[farming_flag]"]').forEach((option) => {
        option.addEventListener("change", () => {
            changeVisible(option.value);
        });
    });

    document.querySelectorAll('input[name="schedule_work_type_term"]').forEach((option) => {
        option.addEventListener("change", () => {
            changeWorkedAtRange(option);
        });
    });

    changeVisible(document.querySelector('input[name="schedule[farming_flag]"]:checked').value);
    changeWorkedAtRange(document.querySelector('input[name="schedule_work_type_term"]:checked'));
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

const changeWorkedAtRange = (option) => {
    const workedAt = document.getElementById("schedule_worked_at");
    if (!workedAt || !option) return;

    const startDate = option.dataset.startDate;
    const endDate = option.dataset.endDate;
    if (!startDate || !endDate) return;

    workedAt.min = startDate;
    workedAt.max = endDate;

    if (workedAt.value && workedAt.value < startDate) workedAt.value = startDate;
    if (workedAt.value && workedAt.value > endDate) workedAt.value = endDate;
}
