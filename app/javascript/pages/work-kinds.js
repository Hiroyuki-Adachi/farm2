export const init = () => {
    document.getElementById("work_kind_land_flag").addEventListener("change", (event) => {
        changeLandFlag(event.target);
    });

    changeLandFlag(document.getElementById("work_kind_land_flag"));
};

const changeLandFlag = (checkbox) => {
    if (checkbox.checked) {
        document.getElementById("work_kind_aggregation_flag").disabled = false;
    } else {
        document.getElementById("work_kind_aggregation_flag").checked = false;
        document.getElementById("work_kind_aggregation_flag").disabled = true;
    }
}
