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

window.addEventListener("DOMContentLoaded", () => {
    const mySideCollapse = new Collapse(document.getElementById("my_side_wrapper"), {toggle: false});

    // for sidebar
    const controller = document.getElementById("current_controller").value;
    const action = document.getElementById("current_action").value;

    if(controller != "menu" || action != "index") {
        document.getElementById("my_sidebar").querySelectorAll("a[data-controller]").forEach((element) => {
            if(element.dataset.controller == controller) {
                if(document.getElementById("my_sidebar").querySelectorAll(`a[data-controller="${controller}"]`).length <= 1) {
                    activeBar(element);
                } else if(JSON.parse(element.dataset.actions).indexOf(action) >= 0) {
                    activeBar(element);
                }
            }
        });
    }

    const handleConfirm = function(event) {
        if (!allowAction(event.target)) {
            Rails.stopEverything(event);
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

    document.querySelectorAll("a[data-confirm], input[data-confirm], button[data-confirm]").forEach((element) => {
        element.addEventListener("click", (event) => {
            handleConfirm(event);
        })
    })

    document.querySelectorAll("#navbarFarm2 a.nav-link").forEach((element) => {
        element.addEventListener("click", () => {
            const my_menu = document.getElementById("menu_dropdown");
            my_menu.innerHTML = document.querySelector(`div[aria-labelledby="${element.id}"]`).innerHTML;
            my_menu.querySelector("span").remove();
            my_menu.dataset.id = element.id;
            my_menu.style.display = "block";

            let left = 0;
            do {
                left += element.offsetLeft || 0;
                element = element.offsetParent;
            } while(element);
            my_menu.style.left = left + "px";
        });
    });
});

window.addEventListener("click", (event) => {
    const my_menu = document.getElementById("menu_dropdown");
    if (!event.target.matches('.nav-link') && (my_menu != null)) {
        my_menu.style.display = "none";
    }
});

function activeBar(element) {
    const navdiv = element.closest("div");
    element.style.backgroundColor = "White";
    navdiv.style.display = "block";
    document.getElementById(navdiv.getAttribute("aria-labelledby")).classList.add("active");
}
