// app/javascript/controllers/pages/trucks_form_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="pages--trucks-form"
export default class extends Controller {
  static targets = ["input", "tabLink"]

  connect() {
    this.dirty = false
  }

  markDirty() {
    this.dirty = true
  }

  navigate(event) {
    if (!this.dirty) return

    event.preventDefault()
    const url = event.currentTarget.href

    window.popupConfirm("保存していませんが、よろしいですか？", (ok) => {
      if (ok) Turbo.visit(url)
    })
  }
}
