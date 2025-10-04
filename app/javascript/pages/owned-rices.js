export const init = () => {
    ("change keyup click".split(" ")).forEach((event) => {
        document.querySelectorAll(".rice").forEach((element) => {
            element.addEventListener(event, () => {
                dispSum();
            });
        });
    });
    dispSum();
};

function dispSum() {
    let owned_rice = 0;
    document.querySelectorAll(".owned-rice").forEach((element) => {
        owned_rice += parseInt(element.value);
    });
    document.getElementById("sum_owned_rice").innerText = owned_rice;
}
