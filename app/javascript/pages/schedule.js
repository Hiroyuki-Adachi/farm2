export const init = () => {
    document.querySelectorAll('input[name="schedule[farming_flag]"]').forEach((option) => {
        option.addEventListener("change", () => {
            changeVisible(option.value);
        });
    });

    changeVisible(document.querySelector('input[name="schedule[farming_flag]"]:checked').value);
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
