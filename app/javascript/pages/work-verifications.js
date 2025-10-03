import "bootstrap";

export const init = () => {
    document.getElementById("print_self").addEventListener("change", (event) => {
        changePrint(event.target);
    });

    document.getElementById('list').addEventListener('click', event => {
        let target = event.target;
        while (target != null && !target.classList.contains('show-work')) {
            if (target === event.currentTarget) return;
            target = target.parentElement;
        }

        if (target && target.classList.contains('show-work')) {
            execShow(target.dataset.url);
            event.preventDefault();
        }
    });

    document.getElementById("print_self").checked = true;
    changePrint(document.getElementById("print_self"));
};

const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
        if (meta.getAttribute('name') === 'csrf-token') {
            return meta.getAttribute('content');
        }
    }
    return '';
};

const execCreate = (url) => {
    verificationModal.hide();
    verificationModal = null;

    loadingStart("承認中...");

    fetch(url, {
        method: "PUT",
        headers: {
            'X-CSRF-Token': getCsrfToken()
        }
    })
        .then((data) => data.text())
        .then((html) => {
            document.getElementById("list").innerHTML = html;
        })
        .then(() => {
            loadingEnd();
            changePrint(document.getElementById("print_self"));
        });
    return false;
}

const execDestroy = (url) => {
    verificationModal.hide();
    verificationModal = null;
    loadingStart("取消中...");

    fetch(url, {
        method: "DELETE",
        headers: {
            'X-CSRF-Token': getCsrfToken()
        }
    })
        .then((data) => data.text())
        .then((html) => {
            document.getElementById("list").innerHTML = html;
        })
        .then(() => {
            loadingEnd();
            changePrint(document.getElementById("print_self"));
        });
    return false;
}

let verificationModal = null;
const execShow = (url) => {
    fetch(url, {
        method: "GET"
    })
        .then((data) => data.text())
        .then((html) => {
            document.getElementById("show_work_content").innerHTML = html;
            verificationModal = new bootstrap.Modal(document.getElementById("show_work"));
            verificationModal.show();
            if (document.getElementById("work_exec") != null) {
                document.getElementById("work_exec").addEventListener("click", (event) => {
                    execCreate(event.target.dataset.url, event.target.dataset.work);
                });
            }
            if (document.getElementById("work_cancel") != null) {
                document.getElementById("work_cancel").addEventListener("click", (event) => {
                    execDestroy(event.target.dataset.url);
                });
            }
            loadingEnd();
        })
    return false;
}

const changePrint = (checkbox) => {
    if (checkbox.checked) {
        document.querySelectorAll("input[name='self_flag']").forEach((element) => {
            element.closest("tr").style.display = "none";
        });
    } else {
        document.querySelectorAll("#tbl_list tr").forEach((element) => {
            element.style.display = "table-row";
        });
    }
}
