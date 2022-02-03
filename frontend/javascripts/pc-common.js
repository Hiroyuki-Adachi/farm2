import { Modal, Collapse } from "bootstrap";
import Rails from "@rails/ujs";
window.popupAlert = (message) => {
    document.getElementById("popup_alert_message").innerText = message;
    const popupForm = new Modal(document.getElementById("popup_alert"));
    popupForm.show();
};

window.popupConfirm = (message, callback) => {
    document.getElementById("popup_confirm_message").innerText = message;
    const popupForm = new Modal(document.getElementById("popup_confirm"));
    document.getElementById("popup_confirm_yes").onclick = () => {
        popupForm.hide();
        callback(true);
    };
    document.getElementById("popup_confirm_no").onclick = () => {
        popupForm.hide();
        callback(false);
    };
    popupForm.show();
}

$(document).on("change", "div.form-check-inline input[type='checkbox']", function(e) {
    if($(this).prop('checked')) {
        $(this).parent().css("color", "red");
    } else {
        $(this).parent().css("color", "black");
    }
});

window.addEventListener("DOMContentLoaded", () => {
    $("div.form-check-inline input[type='checkbox']").trigger("change");
    const mySideCollapse = new Collapse(document.getElementById("my_side_wrapper"), {toggle: false});

    // for sidebar
    const controller = document.getElementById("current_controller").value;
    const action = document.getElementById("current_action").value;
    if(controller == "menu" && action == "index") {
        return;
    }
    $("#my_sidebar").find("a[data-controller]").each(function(_i, e) {
        if(e.dataset.controller == controller) {
            if($("a[data-controller='" + controller + "']").length <= 1) {
                activeBar(e);
            } else if(JSON.parse(e.dataset.actions).indexOf(action) >= 0) {
                activeBar(e);
            }
        }
    });

    const handleConfirm = function(element) {
        if (!allowAction(this)) {
            Rails.stopEverything(element);
        }
    }
	
    const allowAction = function(element) {
        if (element.getAttribute('data-confirm') === null) {
            return true;
        }
        showConfirmationDialog(element);
        return false;
    }

    const confirmed = function(element, result) {
        if (result.value) {
            element.removeAttribute('data-confirm')
            element.click()
        }
    }

    const showConfirmationDialog = function(element) {
        const message = element.getAttribute('data-confirm');
        popupConfirm(message, function(result) {
            confirmed(element, {value: result});
        });
    }

    document.getElementById("my_side_close").addEventListener("click", () => {
        const myContent = document.getElementById("my_content");
        const openButton = document.getElementById("my_side_open");
        mySideCollapse.hide();

        myContent.classList.remove("col-md-10");
        myContent.classList.add("col-md-12");

        openButton.classList.remove("d-none");
        openButton.classList.add("d-block");

        sessionStorage.setItem("my_side", "hide");
    });

    document.getElementById("my_side_open").addEventListener("click", () => {
        const myContent = document.getElementById("my_content");
        const openButton = document.getElementById("my_side_open");
        mySideCollapse.show();

        myContent.classList.remove("col-md-12");
        myContent.classList.add("col-md-10");

        openButton.classList.remove("d-block");
        openButton.classList.add("d-none");

        sessionStorage.setItem("my_side", "show");
    });

    if (sessionStorage.getItem("my_side") == "hide") {
        const mySideWrapper = document.getElementById("my_side_wrapper");
        const myContent = document.getElementById("my_content");
        const openButton = document.getElementById("my_side_open");
    
        mySideWrapper.classList.remove("show");
    
        myContent.classList.remove("col-md-10");
        myContent.classList.add("col-md-12");
    
        openButton.classList.remove("d-none");
        openButton.classList.add("d-block");
    }

    $("a[data-confirm], input[data-confirm], button[data-confirm]").on('click', handleConfirm);
});

// for side-bar
function activeBar(e) {
    var navdiv = $(e).parent("div");
    e.style.backgroundColor = "White";
    navdiv.show();
    $("#" + navdiv.attr("aria-labelledby")).addClass("active");
}
