import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "checkbox"]

  connect() {
    this.reset()
  }

  toggle() {
    this.inputTarget.type = this.checkboxTarget.checked ? "text" : "password"
  }

  reset() {
    this.checkboxTarget.checked = false
    this.inputTarget.type = "password"
  }
}
