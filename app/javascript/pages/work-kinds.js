export const init = () => {
    const landFlag = document.getElementById("work_kind_land_flag");
    const aggregationFlag = document.getElementById("work_kind_aggregation_flag");

    if (landFlag) {
        landFlag.addEventListener("change", (event) => {
            changeLandFlag(event.target);
        });

        changeLandFlag(landFlag);
    } else if (aggregationFlag) {
        aggregationFlag.checked = false;
        aggregationFlag.disabled = true;
    }
};

const changeLandFlag = (checkbox) => {
    const aggregationFlag = document.getElementById("work_kind_aggregation_flag");

    if (!aggregationFlag) {
        return;
    }

    if (checkbox.checked) {
        aggregationFlag.disabled = false;
    } else {
        aggregationFlag.checked = false;
        aggregationFlag.disabled = true;
    }
}
