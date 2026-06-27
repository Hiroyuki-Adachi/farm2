import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = window.bootstrap?.Modal?.getOrCreateInstance(this.element)
    if (!this.modal) return

    this.onHidden = () => {
      const frame = this.element.closest("turbo-frame")
      if (frame) frame.innerHTML = ""
    }

    this.element.addEventListener("hidden.bs.modal", this.onHidden, { once: true })
    this.modal.show()
  }

  disconnect() {
    if (!this.element.classList.contains("show")) return

    this.modal?.dispose()
    document.querySelectorAll(".modal-backdrop").forEach((backdrop) => backdrop.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("padding-right")
  }
}
