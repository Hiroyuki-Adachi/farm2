import { Turbo } from "@hotwired/turbo-rails";

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
    const currentController = document.getElementById("current_controller");
    const currentAction = document.getElementById("current_action");
    const myMenu = document.getElementById("menu_dropdown");
    const mySidebar = document.getElementById("my_sidebar");

    if (currentController != null || currentAction != null) {
        const controllerValue = currentController.value;
        const actionValue = currentAction.value;
    
        if(mySidebar != null && (controllerValue != "menu" || actionValue != "index")) {
            mySidebar.querySelectorAll("a[data-controller]").forEach((element) => {
                if(element.dataset.controller == controllerValue) {
                    if(mySidebar.querySelectorAll(`a[data-controller="${controllerValue}"]`).length <= 1) {
                        activeBar(element);
                    } else if(JSON.parse(element.dataset.actions).indexOf(actionValue) >= 0) {
                        activeBar(element);
                    }
                }
            });
        }
    }

    document.querySelectorAll("#navbarFarm2 a.farm2-navi").forEach((element) => {
        element.addEventListener("click", (event) => {
            myMenu.innerHTML = document.querySelector(`div[aria-labelledby="${event.target.id}"]`).innerHTML;
            myMenu.querySelector("span").remove();
            myMenu.dataset.id = event.target.id;
            myMenu.style.display = "block";

            let left = 0;
            let elm = event.target;
            do {
                left += elm.offsetLeft || 0;
                elm = elm.offsetParent;
            } while(elm);
            myMenu.style.left = left + "px";
            event.stopPropagation();
        });
    });

    window.addEventListener("click", (event) => {
        if (!event.target.matches('.nav-link') && (myMenu != null)) {
            myMenu.style.display = "none";
            event.stopPropagation();
        }
    });

    Array.from(document.getElementsByClassName("tr-total1")).forEach((element) => {
        element.addEventListener("click", (event) => {
            const totalTr = event.target.closest("tr");
            document.querySelectorAll(`.tr-total2[data-code1="${totalTr.dataset.code1}"]`).forEach((tr) => {
                tr.style.display = (tr.style.display == "none") ? "table-row" : "none";
            });
            document.querySelectorAll(`.tr-detail[data-code1="${totalTr.dataset.code1}"]`).forEach((tr) => {
                if (document.querySelector(`.tr-total2[data-code1="${tr.dataset.code1}"][data-code2="${tr.dataset.code2}"]`).style.display == "none") {
                    tr.style.display = "none";
                }
            });
        });
    });
    Array.from(document.getElementsByClassName("tr-total2")).forEach((element) => {
        element.addEventListener("click", (event) => {
            const totalTr = event.target.closest("tr");
            document.querySelectorAll(`.tr-detail[data-code1="${totalTr.dataset.code1}"][data-code2="${totalTr.dataset.code2}"]`).forEach((tr) => {
                tr.style.display = (tr.style.display == "none") ? "table-row" : "none";
            });
        });
    });

    document.querySelectorAll(".tr-total2, .tr-detail").forEach((element) => {
        element.style.display = "none";
    });

    window.addEventListener("turbo:click", () => {
        loadingStart("しばらくお待ちください");
    });

    window.addEventListener("turbo:loading", () => {
        loadingEnd();
    });
    window.addEventListener("turbo:frame-load", () => {
        loadingEnd();
    });
});

function activeBar(element) {
    const navdiv = element.closest("div");
    element.style.backgroundColor = "White";
    navdiv.style.display = "block";
    document.getElementById(navdiv.getAttribute("aria-labelledby")).classList.add("active");
}

function loadingStart(message)
{
    document.getElementById("loading_message").innerText = message;
    document.getElementById("loading").classList.remove("d-none");
}

function loadingEnd()
{
    document.getElementById("loading").classList.add("d-none");
}

window.loadingStart = loadingStart;
window.loadingEnd = loadingEnd;
