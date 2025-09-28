import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs";

window.addEventListener('turbo:load', () => {
    Sortable.create(document.getElementById("tbody_lands"), {
        onSort: renumberLands
    });

    renumberLands();
});

function renumberLands() {
    document.querySelectorAll("#tbody_lands tr").forEach((element, index) => {
        element.querySelector(".lineNo").innerText = index + 1;
        element.querySelector(".land_info").querySelector("input[id$='display_order']").value = index + 1;
    });
}

export default class extends Controller {}
