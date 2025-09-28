// app/javascript/controllers/row_visit_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  click() { Turbo.visit(this.urlValue) }
  keydown(e) {
    if (e.key === "Enter" || e.key === " ") { e.preventDefault(); this.click() }
  }
}
