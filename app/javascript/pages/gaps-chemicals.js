export const init = () => {
    document.getElementById("chemical_type_id").addEventListener("change", () => {
        loadingStart("計算中");
        document.getElementById("search_form").requestSubmit();
    });
};
