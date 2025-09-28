export const init = () => {
    document.getElementById("work_type_id").addEventListener("change", () => {
        loadingStart("集計中");
        document.getElementById("search_form").requestSubmit();
    });
};
