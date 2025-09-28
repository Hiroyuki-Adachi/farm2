import "bootstrap";

export const init = () => {
    loadChemical(document.getElementById("term").value, document.getElementById("chemical_type").value);

    document.getElementById("term").addEventListener("change", (event) => {
        loadChemical(event.target.value, document.getElementById("chemical_type").value);
    });
    document.getElementById("chemical_type").addEventListener("change", (event) => {
        loadChemical(document.getElementById("term").value, event.target.value);
    });
    document.getElementById("search").addEventListener("click", (event) => {
        doSearch();
    });
    document.getElementById("new_button").addEventListener("click", (event) => {
        fetch(document.getElementById("new_path").value)
        .then((data) => data.text())
        .then((html) => {
            const modalForm = document.getElementById("modal_form");
            modalForm.innerHTML = html;
            popupModal(modalForm);
        });
    });
};

function loadChemical(term, chemicalType)
{
    fetch(`${document.getElementById("load_path").value}?term=${term}&chemical_type_id=${chemicalType}`)
    .then((data) => data.text())
    .then((html) => {
        document.getElementById("chemical_id").innerHTML = html;
    });
}

function doSearch()
{
    loadingStart("検索中");
    fetch(document.getElementById("search_path").value.replace('0', document.getElementById("chemical_id").value))
    .then((data) => data.text())
    .then((html) => {
        document.getElementById("search_result").innerHTML = html;
        document.getElementById("new_button").disabled = false;
        addEventForEdit();
        loadingEnd();
    });
}

function addEventForEdit()
{
    document.querySelectorAll(".edit-button").forEach((element) => {
        element.addEventListener("click", (event) => {
            fetch(event.target.dataset.path)
            .then((data) => data.text())
            .then((html) => {
                const modalForm = document.getElementById("modal_form");
                modalForm.innerHTML = html;
                popupModal(modalForm);
            });
        });
    });
}

function popupModal(modalForm)
{
    const popup = new bootstrap.Modal(modalForm);
    popup.show();

    document.getElementById("update_button").addEventListener("click", (event) => {
        const form = document.getElementById("update_form");
        fetch(form.action, {
            method: "POST",
            body: new FormData(form)
        })
        .then((res) => {
            if (res.ok) {
                popup.hide();
                doSearch();
            }
        });
    });

    if (document.getElementById("delete_button") != null) {
        document.getElementById("delete_button").addEventListener("click", (event) => {
            let deleteForm = new FormData(document.getElementById("update_form"));
            deleteForm.append("_method", "delete");

            fetch(document.getElementById("update_form").action, {
                method: "DELETE",
                body: deleteForm
            })
            .then((res) => {
                if (res.ok) {
                    popup.hide();
                    doSearch();
                }
            });
        });
    }
}
