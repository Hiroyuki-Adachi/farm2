export const init = () => {
    document.getElementById("adjustment_home_sql").value = document.getElementById("drying_adjustment_attributes_home_id").innerHTML;

    document.querySelectorAll('input[type="number"][name$="[moth_weight]"], input[type="number"][name$="[rice_weight]"]').forEach((element) => {
        element.addEventListener("change", () => {
            calcSum();
        });
    });

    document.querySelectorAll('input[name="drying[drying_type_id]"]').forEach((element) => {
        element.addEventListener("change", () => {
            changeEnabled();
        });
    });

    document.getElementById("drying_adjustment_attributes_waste_weight").addEventListener("blur", () => {
        wasteWeight2Bag();
    });

    document.getElementById("waste_weight_bag").addEventListener("blur", () => {
        wasteBag2Weight();
    });

    document.getElementById("drying_adjustment_attributes_rice_bag").addEventListener("blur", () => {
        rice2Container();
    });

    document.getElementById("drying_adjustment_attributes_half_weight").addEventListener("blur", () => {
        rice2Container();
    });

    document.getElementById("contaier_weight").addEventListener("blur", (event) => {
        const fleconWeight = new Decimal(event.target.value == "" ? 0 : event.target.value);
        const perBag = new Decimal(document.getElementById("kg_per_bag_rice").value);
    
        document.getElementById("drying_adjustment_attributes_rice_bag").value = fleconWeight.div(perBag).toFixed(0);
        document.getElementById("drying_adjustment_attributes_half_weight").value = fleconWeight.mod(perBag).toFixed(0);
    });

    calcSum();
    changeEnabled();
    wasteWeight2Bag();
};

function calcSum() {
    const sum_moth = sumWeight('input[type="number"][name$="[moth_weight]"]');
    const sum_rice = sumWeight('input[type="number"][name$="[rice_weight]"]');
    const formatter = new Intl.NumberFormat('ja-JP', {minimumFractionDigits: 1});
  
    document.getElementById("sum_moth_weight").innerText = formatter.format(sum_moth);
    document.getElementById("sum_rice_weight").innerText = formatter.format(sum_rice);
}

function sumWeight(selector) {
    let sum_weight = 0;
    document.querySelectorAll(selector).forEach((element) => {
        if (element.value != "" && !isNaN(element.value)) {
            sum_weight += parseFloat(element.value);
        }
    });

    return sum_weight;
}

function changeEnabled() {
    const dry_type = document.querySelector('input[name="drying[drying_type_id]"]:checked').value;

    if(dry_type == undefined) {
        document.querySelectorAll(".dry-input").forEach((element) => {
            element.disabled = true;
        });
        return;
    }

    document.querySelectorAll(".dry-input").forEach((element) => {
        element.disabled = false;
    });
    document.querySelectorAll("input.dry-country, input.dry-another, input.dry-self").forEach((element) => {
        element.readOnly = true;
    });
    document.querySelectorAll("select.dry-country, select.dry-another, select.dry-self").forEach((element) => {
        element.disabled = false;
    });
    switch(dry_type) {
        case 'country':
            document.querySelectorAll("input.dry-country").forEach((element) => {
                element.readOnly = false;
            });
            document.querySelectorAll("input.dry-another, input.dry-self").forEach((element) => {
                if (!element.classList.contains("dry-country")) {
                    element.value = "";
                    element.disabled = true;
                }
            });
            document.getElementById("drying_adjustment_attributes_home_id").value = "";
            break;

        case 'self':
            document.querySelectorAll("input.dry-self").forEach((element) => {
                element.readOnly = false;
            });
            document.querySelectorAll("input.dry-another, input.dry-country").forEach((element) => {
                if (!element.classList.contains("dry-self")) {
                    element.value = "";
                    element.disabled = true;
                }
            });
            document.getElementById("drying_adjustment_attributes_home_id").innerHTML = document.getElementById("adjustment_home_sql").value;
            document.getElementById("drying_adjustment_attributes_home_id").value = document.getElementById("drying_home_id").value;
            break;

        case 'another':
            document.querySelectorAll("input.dry-another").forEach((element) => {
                element.readOnly = false;
            });
            document.querySelector(`#drying_adjustment_attributes_home_id option[value="${document.getElementById("drying_home_id").value}"]`).remove();
            break;
    }

    if (document.getElementById("drying_shipped_on").value == "") {
        let carryOn = new Date(document.getElementById("carried_on").value);
        carryOn.setDate(carryOn.getDate() + 1);
        document.getElementById("drying_shipped_on").value = `${carryOn.getFullYear()}-${("0" + (carryOn.getMonth() + 1)).slice(-2)}-${("0" + carryOn.getDate()).slice(-2)}`;
    }
}

document.addEventListener("paste", function (e) {
    if (e.clipboardData && e.clipboardData.getData) {
        const dry_type = document.querySelector('input[name="drying[drying_type_id]"]:checked').value;
        if(dry_type == undefined) return;

        const clip = e.clipboardData.getData('text/plain');
        switch(dry_type) {
          case 'country':
            pasteDry(clip);
            break;

          case 'self':
          case 'another':
            pasteAdjust(clip);
            break;
        }

        calcSum();
    }
});

function pasteDry(clip) {
    const lines = clip.split("\n");
    for(let i = 0; i < lines.length; i++) {
        const weights = lines[i].split("\t");
        if(weights.length < 3) continue;
        weights[1] = weights[1].replace(/,/g, "");
        weights[2] = weights[2].replace(/,/g, "");

        if(!isNaN(weights[0])) {
            document.getElementById(`drying_drying_moths_attributes_${i}_moth_no`).value = weights[0];
        }
        if(!isNaN(weights[1])) {
            document.getElementById(`drying_drying_moths_attributes_${i}_moth_weight`).value = weights[1];
        }
        if(!isNaN(weights[2])) {
            document.getElementById(`drying_drying_moths_attributes_${i}_rice_weight`).value = weights[2];
        }
    }
}

function pasteAdjust(clip) {
    const bag = clip.replace(/(\t|\n)/g, "");
    if(!isNaN(bag)) {
        document.getElementById("drying_adjustment_attributes_rice_bag").value = bag;
    }
}

function wasteWeight2Bag() {
    const waste_weight = parseInt(document.getElementById("drying_adjustment_attributes_waste_weight").value, 10);
    const KG_PER_BAG_WASTE = parseInt(document.getElementById("kg_per_bag_waste").value, 10);
    document.getElementById("waste_weight_bag").value = isNaN(waste_weight) ? 0 : Math.floor(waste_weight / KG_PER_BAG_WASTE);
}

function wasteBag2Weight() {
    const waste_bag = parseInt(document.getElementById("waste_weight_bag").value, 10);
    const KG_PER_BAG_WASTE = parseInt(document.getElementById("kg_per_bag_waste").value, 10);
    document.getElementById("drying_adjustment_attributes_waste_weight").value = isNaN(waste_bag) ? 0 : waste_bag * KG_PER_BAG_WASTE;
}

function rice2Container()
{
    const riceBagValue = document.getElementById("drying_adjustment_attributes_rice_bag").value;
    const riceBag = new Decimal(riceBagValue == "" ? 0 : riceBagValue);
    const halfWeightValue = document.getElementById("drying_adjustment_attributes_half_weight").value;
    const halfWeight = new Decimal(halfWeightValue == "" ? 0 : halfWeightValue);
    const perBag = new Decimal(document.getElementById("kg_per_bag_rice").value);

    document.getElementById("contaier_weight").value = riceBag.mul(perBag).plus(halfWeight).toFixed(0);
}
