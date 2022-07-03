import { Modal } from "bootstrap";

window.addEventListener("load", () => {
  const popupForm = new Modal(document.getElementById("kamoku_modal"));

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
});
