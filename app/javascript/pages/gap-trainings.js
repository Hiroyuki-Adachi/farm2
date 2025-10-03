export const init = () => {
    document.getElementById("study").addEventListener("change", (event) => {
        document.querySelectorAll(".studies").forEach((element) => {
            element.disabled = !event.target.checked;
        });
    });
};
