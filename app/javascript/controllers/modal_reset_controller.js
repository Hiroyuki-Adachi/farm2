// app/javascript/controllers/modal_reset_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: String, frameSrc: String };

  connect() {
    this.onShow = (e) => {
      const trigger = e.relatedTarget; // これが押したボタン
      const urlFromButton = trigger?.dataset?.modalResetFrameSrcValue;
      const url = urlFromButton || this.frameSrcValue; // ボタン優先、無ければ固定値
      const frame = document.getElementById(this.frameIdValue);
      if (frame && url) frame.src = url;
    }

    this.onHidden = () => {
      const frame = document.getElementById(this.frameIdValue);
      if (!frame) return;
      // 中身を空にして、次回のために src を復元
      frame.innerHTML = "";
      if (this.hasFrameSrcValue) frame.setAttribute("src", this.frameSrcValue);
    }

    this.element.addEventListener("show.bs.modal", this.onShow);
    this.element.addEventListener("hidden.bs.modal", this.onHidden);
  }

  disconnect() {
    this.element.removeEventListener("show.bs.modal", this.onShow);
    this.element.removeEventListener("hidden.bs.modal", this.onHidden);
  }
}
