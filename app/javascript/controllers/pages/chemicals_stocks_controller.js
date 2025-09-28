import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

function loadChemical(term, chemicalType) {
  fetch(
    `${document.getElementById("load_path").value}?term=${term}&chemical_type_id=${chemicalType}`
  )
    .then((data) => data.text())
    .then((html) => {
      document.getElementById("chemical_id").innerHTML = html
    })
}

function popupModal(modalForm) {
  const popup = new bootstrap.Modal(modalForm)
  popup.show()

  document.getElementById("update_button").addEventListener("click", () => {
    const form = document.getElementById("update_form")
    fetch(form.action, {
      method: "POST",
      body: new FormData(form)
    }).then((res) => {
      if (res.ok) {
        popup.hide()
        doSearch()
      }
    })
  })

  const deleteButton = document.getElementById("delete_button")
  if (deleteButton) {
    deleteButton.addEventListener("click", () => {
      const form = document.getElementById("update_form")
      if (!form) return
      const deleteForm = new FormData(form)
      deleteForm.append("_method", "delete")

      fetch(form.action, {
        method: "DELETE",
        body: deleteForm
      }).then((res) => {
        if (res.ok) {
          popup.hide()
          doSearch()
        }
      })
    })
  }
}

function addEventForEdit() {
  document.querySelectorAll(".edit-button").forEach((element) => {
    element.addEventListener("click", (event) => {
      fetch(event.target.dataset.path)
        .then((data) => data.text())
        .then((html) => {
          const modalForm = document.getElementById("modal_form")
          modalForm.innerHTML = html
          popupModal(modalForm)
        })
    })
  })
}

function doSearch() {
  window.loadingStart?.("検索中")
  fetch(
    document
      .getElementById("search_path")
      .value.replace("0", document.getElementById("chemical_id").value)
  )
    .then((data) => data.text())
    .then((html) => {
      document.getElementById("search_result").innerHTML = html
      document.getElementById("new_button").disabled = false
      addEventForEdit()
      window.loadingEnd?.()
    })
}

window.addEventListener("turbo:load", () => {
  loadChemical(
    document.getElementById("term").value,
    document.getElementById("chemical_type").value
  )

  document.getElementById("term").addEventListener("change", (event) => {
    loadChemical(event.target.value, document.getElementById("chemical_type").value)
  })
  document.getElementById("chemical_type").addEventListener("change", (event) => {
    loadChemical(document.getElementById("term").value, event.target.value)
  })
  document.getElementById("search").addEventListener("click", () => {
    doSearch()
  })
  document.getElementById("new_button").addEventListener("click", () => {
    fetch(document.getElementById("new_path").value)
      .then((data) => data.text())
      .then((html) => {
        const modalForm = document.getElementById("modal_form")
        modalForm.innerHTML = html
        popupModal(modalForm)
      })
  })
})

export default class extends Controller {}
