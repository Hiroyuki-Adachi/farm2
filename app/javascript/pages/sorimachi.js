import "bootstrap";

export const init = () => {
  const totalModal = document.getElementById("total_modal");
  const totalForm = totalModal ? new bootstrap.Modal(totalModal) : null;
  const totalButton = document.getElementById("total_button");
  const totalClose = document.getElementById("total_close");
  if (!totalButton || !totalForm || !totalClose) return;

  totalClose.addEventListener("click", () => {
    totalForm.hide();
  });

  totalButton.addEventListener("click", (event) => {
    fetch(event.target.dataset.url)
    .then((res) => {
      if (res.ok) {
        return res.text();
      }
    })
    .then((data) => {
      document.getElementById("total_body").innerHTML = data;
      totalForm.show();
    });
  });
};
