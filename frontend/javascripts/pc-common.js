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

    const newConfirmMethod = async (message, element) => {
        try {
            const result = await promiseConfirm(message);
            if (result != null) {
                return result;
            }
        } finally {
            return false;
        }
    };

    const promiseConfirm = (message) => {
        return new Promise((resolve) => {
            popupConfirm(message, function(result) {
                return resolve(result);
            });
        });
    };

    Turbo.setConfirmMethod(newConfirmMethod);
    window.newConfirmMethod = newConfirmMethod;

    if (mySideClose != null) {
        mySideClose.addEventListener("click", () => {
            const myContent = document.getElementById("my_content");
            mySideCollapse.hide();
    
            myContent.classList.remove("col-md-10");
            myContent.classList.add("col-md-12");
    
            mySideOpen.classList.remove("d-none");
            mySideOpen.classList.add("d-block");
    
            sessionStorage.setItem("my_side", "hide");
        });
    }

    if (mySideOpen != null) {
        mySideOpen.addEventListener("click", () => {
            const myContent = document.getElementById("my_content");
            mySideCollapse.show();
    
            myContent.classList.remove("col-md-12");
            myContent.classList.add("col-md-10");
    
            mySideOpen.classList.remove("d-block");
            mySideOpen.classList.add("d-none");
    
            sessionStorage.setItem("my_side", "show");
        });
    }

    if (sessionStorage.getItem("my_side") == "hide") {
        const mySideWrapper = document.getElementById("my_side_wrapper");
        const myContent = document.getElementById("my_content");
    
        mySideWrapper.classList.remove("show");
    
        myContent.classList.remove("col-md-10");
        myContent.classList.add("col-md-12");
    
        mySideOpen.classList.remove("d-none");
        mySideOpen.classList.add("d-block");
    }

    document.querySelectorAll("a[data-confirm], input[data-confirm], button[data-confirm]").forEach((element) => {
        element.addEventListener("click", (event) => {
            handleConfirm(event);
        })
    })

    document.querySelectorAll("#navbarFarm2 a.nav-link").forEach((element) => {
        element.addEventListener("click", () => {
            if (sessionStorage.getItem("my_side") == "hide") {
                myMenu.innerHTML = document.querySelector(`div[aria-labelledby="${element.id}"]`).innerHTML;
                myMenu.querySelector("span").remove();
                myMenu.dataset.id = element.id;
                myMenu.style.display = "block";

                let left = 0;
                do {
                    left += element.offsetLeft || 0;
                    element = element.offsetParent;
                } while(element);
                myMenu.style.left = left + "px";
            } else {
                Turbo.visit(element.dataset.url);
            }
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
