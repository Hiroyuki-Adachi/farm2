export const init = () => {
    document.getElementById("term").addEventListener("change", () => {
        document.getElementById("search_form").requestSubmit();
    });
};
