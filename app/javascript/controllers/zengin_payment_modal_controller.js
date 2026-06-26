import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const modal = window.bootstrap?.Modal?.getOrCreateInstance(this.element)
    if (!modal) return

    const onHidden = () => {
      const frame = this.element.closest("turbo-frame")
      if (frame) frame.innerHTML = ""
    }

    this.element.addEventListener("hidden.bs.modal", onHidden, { once: true })
    modal.show()
  }
}
