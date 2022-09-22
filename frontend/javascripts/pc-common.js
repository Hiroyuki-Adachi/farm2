import { Modal, Collapse } from "bootstrap";

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

Turbo.setConfirmMethod((message, element) => {
    document.getElementById("popup_confirm_message").innerText = message;
    const popupForm = new Modal(document.getElementById("popup_confirm"));
    popupForm.show();
  
    return new Promise((resolve, reject) => {
        popupForm._element.querySelectorAll(".confirm-button").forEach((button) => {
            button.addEventListener("click", () => {
                resolve(button.value == "true");
                popupForm.hide();
            }, {once: true});
        });
    });
});

document.addEventListener('turbo:load', () => {
    // for sidebar
    const controller = document.getElementById("current_controller").value;
    const action = document.getElementById("current_action").value;
    const myMenu = document.getElementById("menu_dropdown");
    const mySideClose = document.getElementById("my_side_close");
    const mySideOpen = document.getElementById("my_side_open");

    if(controller != "menu" || action != "index") {
        const mySidebar = document.getElementById("my_sidebar");
        if (mySidebar != null) {
            mySidebar.querySelectorAll("a[data-controller]").forEach((element) => {
                if(element.dataset.controller == controller) {
                    if(mySidebar.querySelectorAll(`a[data-controller="${controller}"]`).length <= 1) {
                        activeBar(element);
                    } else if(JSON.parse(element.dataset.actions).indexOf(action) >= 0) {
                        activeBar(element);
                    }
                }
            });
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
    const myMenu = document.getElementById("menu_dropdown");
    if (!event.target.matches('.nav-link') && (myMenu != null)) {
        myMenu.style.display = "none";
    }
});

function activeBar(element) {
    const navdiv = element.closest("div");
    element.style.backgroundColor = "White";
    navdiv.style.display = "block";
    document.getElementById(navdiv.getAttribute("aria-labelledby")).classList.add("active");
}
