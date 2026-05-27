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
            element.style.display = "";
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

    if (!workedAt.value || (workedAt.value >= startDate && workedAt.value <= endDate)) return;

    const today = localDateString(new Date());
    if (today >= startDate && today <= endDate) {
        workedAt.value = today;
    } else if (workedAt.value < startDate) {
        workedAt.value = startDate;
    } else {
        workedAt.value = endDate;
    }
}

const localDateString = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
}
