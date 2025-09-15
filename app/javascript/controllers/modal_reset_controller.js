// app/javascript/controllers/modal_reset_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: String, frameSrc: String }

  connect() {
    this.onHidden = () => {
      const frame = document.getElementById(this.frameIdValue)
      if (!frame) return
      // 中身を空にして、次回のために src を復元
      frame.innerHTML = ""
      if (this.hasFrameSrcValue) frame.setAttribute("src", this.frameSrcValue)
    }
    this.element.addEventListener("hidden.bs.modal", this.onHidden)
  }

  disconnect() {
    this.element.removeEventListener("hidden.bs.modal", this.onHidden)
  }
}
