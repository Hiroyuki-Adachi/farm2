import { Decimal } from "decimal.js";

export const init = () => {
    document.getElementById("prorate").addEventListener("click", (event) => {
        let totalArea = new Decimal(0);
        const totalSoil = new Decimal(document.getElementById("soil_quantity_sum").value);
        let sum_soil = new Decimal(0);
        let max_work_type = 0;
        let max_area = 0;
        let max_soil = 0;
        document.querySelectorAll('[name="check_soil"]:checked').forEach((element) => {
            const cur_work_type = element.value;
            const cur_area = new Decimal(document.getElementById(`land_${cur_work_type}`).value);

            totalArea = totalArea.plus(cur_area);
            if(max_area < cur_area) {
                max_area = cur_area;
                max_work_type = cur_work_type;
            }
        });

        if((totalArea > 0) && (totalSoil > 0)) {
            document.querySelectorAll('[name="seedlings[][soil_quantity]"').forEach((element) => {
                element.value = 0;
            });
            document.querySelectorAll('[name="check_soil"]:checked').forEach((element) => {
                const cur_work_type = element.value;
                const cur_area = new Decimal(document.getElementById(`land_${cur_work_type}`).value);
                const cur_soil = totalSoil.mul(cur_area).div(totalArea).round();

                sum_soil = sum_soil.plus(cur_soil);
                document.getElementById(`soil_quantity_${cur_work_type}`).value = cur_soil;
                if(cur_work_type == max_work_type) {
                    max_soil = cur_soil;
                }
            });
            if(sum_soil != totalSoil) {
                document.getElementById(`soil_quantity_${max_work_type}`).value = max_soil.plus(totalSoil.minus( sum_soil));
            }
        }
    });
};
