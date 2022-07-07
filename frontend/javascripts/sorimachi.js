import { Modal } from "bootstrap";

window.addEventListener("load", () => {
  const popupForm = new Modal(document.getElementById("kamoku_modal"));

  const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
      if (meta.getAttribute('name') === 'csrf-token') {
        return meta.getAttribute('content');
      }
    }
    return '';
  }

  document.querySelectorAll("button.has-details").forEach((element) => {
      element.addEventListener("click", (event) => {
        const dispFlag = (element.dataset.details != "true");
        element.dataset.details = dispFlag.toString();
        document.querySelectorAll(`[data-detail-line="${element.dataset.line}"]`).forEach((detail) => {
          detail.style.display = dispFlag ? "table-row" : "none";
        });
      });
    });
  
    document.querySelectorAll("button.edit-work-types").forEach((element) => {
      element.addEventListener("click", (event) => {
        fetch(element.dataset.url)
        .then((response) => {
          return response.text();
        })
        .then((data) => {
          document.getElementById("kamoku_body").innerHTML = data;
          popupForm.show();
        });
      });
    });

  document.getElementById("kamoku_close").addEventListener("click", () => {
    popupForm.hide();
  });

  document.getElementById("kamoku_delete").addEventListener("click", (event) => {
    const journal_id = document.getElementById("sorimachi_id").value;
    fetch(event.target.dataset.url.replace("@", journal_id), {
      method: "DELETE",
      headers: {
        'X-CSRF-Token': getCsrfToken()
      }
    })
    .then((response) => {
      return response.text();
    })
    .then((data) => {
      document.getElementById(`tr_${journal_id}`).innerHTML = data;
      popupForm.hide();
    });
  });
});
