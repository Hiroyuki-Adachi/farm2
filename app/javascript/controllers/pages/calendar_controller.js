import { Controller } from "@hotwired/stimulus"

const checkWeather = (checkbox) => {
  if (!checkbox) return
  document.querySelectorAll(checkbox.dataset.css || "").forEach((element) => {
    element.style.display = checkbox.checked ? "block" : "none"
  })
}

window.addEventListener("turbo:load", () => {
  document.querySelectorAll(".check-weather").forEach((element) => {
    element.addEventListener("change", (event) => {
      checkWeather(event.target)
    })
  })

  checkWeather(document.getElementById("check_temprature"))
  checkWeather(document.getElementById("check_water"))
  checkWeather(document.getElementById("check_wind"))
  checkWeather(document.getElementById("check_other"))
})

export default class extends Controller {}
