window.addEventListener("load", () => {
    document.getElementById("adjustment_home_sql").value = document.getElementById("drying_adjustment_attributes_home_id").innerHTML;

    document.querySelectorAll('input[type="number"][name$="[moth_weight]"], input[type="number"][name$="[rice_weight]"]').forEach((element) => {
        element.addEventListener("change", () => {
            calc_sum();
        });
    });

    document.querySelectorAll('input[name="drying[drying_type_id]"]').forEach((element) => {
        element.addEventListener("change", () => {
            change_enabled();
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

    calc_sum();
    change_enabled();
    wasteWeight2Bag();
});

function calc_sum() {
    const sum_moth = sum_weight('input[type="number"][name$="[moth_weight]"]');
    const sum_rice = sum_weight('input[type="number"][name$="[rice_weight]"]');
    const formatter = new Intl.NumberFormat('ja-JP', {minimumFractionDigits: 1});
  
    document.getElementById("sum_moth_weight").innerText = formatter.format(sum_moth);
    document.getElementById("sum_rice_weight").innerText = formatter.format(sum_rice);
}

function sum_weight(selector) {
    let sum_weight = 0;
    $(selector).each(function() {
        if($.isNumeric($(this).val())) {
            sum_weight += parseFloat($(this).val());
        }
    });

    return sum_weight;
}

function change_enabled() {
    const dry_type = $('input[name="drying[drying_type_id]"]:checked').val();

    if(dry_type == undefined) {
        $(".dry-input").prop("disabled", true);
        return;
    }

    $(".dry-input").prop("disabled", false);
    $("input.dry-country, input.dry-another, input.dry-self").prop("readonly", true);
    $("select.dry-country, select.dry-another, select.dry-self").removeAttr("disabled");
    switch(dry_type * 1) {
        case 1: // Country
          $("input.dry-country").prop("readonly", false);
          $("input.dry-another, input.dry-self").not(".dry-country").val("");
          $("#drying_adjustment_attributes_home_id").val("");
          $("select.dry-another, select.dry-self").not(".dry-country").prop('disabled', 'disabled');
          break;

        case 2: // Self
          $("input.dry-self").prop("readonly", false);
          $("input.dry-another, input.dry-country").not(".dry-self").val("");
          document.getElementById("drying_adjustment_attributes_home_id").innerHTML = document.getElementById("adjustment_home_sql").value;
          $("#drying_adjustment_attributes_home_id").val($("#drying_home_id").val());
          $("select.dry-another, select.dry-country").not(".dry-self").prop('disabled', 'disabled');
          break;

        case 3: // Another
          $("input.dry-another").prop("readonly", false);
          $("#drying_adjustment_attributes_home_id option[value='" + $("#drying_home_id").val() + "']").remove();
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
        const dry_type = $('input[name="drying[drying_type_id]"]:checked').val();
        if(dry_type == undefined) return;

        const clip = e.clipboardData.getData('text/plain');
        switch(dry_type * 1) {
          case 1: // Country
            paste_dry(clip);
            break;

          case 2:
          case 3:
            paste_adjust(clip);
            break;
        }

        calc_sum();
    }
});

function paste_dry(clip) {
    const lines = clip.split("\n");
    for(let i = 0; i < lines.length; i++) {
        const weights = lines[i].split("\t");
        if(weights.length < 3) continue;
        weights[1] = weights[1].replace(/,/g, "");
        weights[2] = weights[2].replace(/,/g, "");

        if($.isNumeric(weights[0])) $(`#drying_drying_moths_attributes_${i}_moth_no`).val(weights[0]);
        if($.isNumeric(weights[1])) $(`#drying_drying_moths_attributes_${i}_moth_weight`).val(weights[1]);
        if($.isNumeric(weights[2])) $(`#drying_drying_moths_attributes_${i}_rice_weight`).val(weights[2]);
    }
}

function paste_adjust(clip) {
    const bag = clip.replace(/(\t|\n)/g, "");
    if($.isNumeric(bag)) $("#drying_adjustment_attributes_rice_bag").val(bag);
}

function wasteWeight2Bag() {
    const waste_weight = parseInt($("#drying_adjustment_attributes_waste_weight").val(), 10);
    const KG_PER_BAG_WASTE = parseInt(document.getElementById("kg_per_bag_waste").value, 10);
    $("#waste_weight_bag").val(isNaN(waste_weight) ? 0 : Math.floor(waste_weight / KG_PER_BAG_WASTE));
}

function wasteBag2Weight() {
    const waste_bag = parseInt($("#waste_weight_bag").val(), 10);
    const KG_PER_BAG_WASTE = parseInt(document.getElementById("kg_per_bag_waste").value, 10);
    $("#drying_adjustment_attributes_waste_weight").val(isNaN(waste_bag) ? 0 : waste_bag * KG_PER_BAG_WASTE);
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
