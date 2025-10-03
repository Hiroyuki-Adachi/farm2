// app/javascript/controllers/modal_reset_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: String, frameSrc: String };

  connect() {
    this.onShow = (e) => {
      const trigger = e.relatedTarget; // クリックされたボタン（無い場合もある）
      const urlFromButton = trigger?.dataset?.modalResetFrameSrcValue;
      const baseUrl = urlFromButton || this.frameSrcValue;
      const frame = document.getElementById(this.frameIdValue);
      const title = trigger?.dataset?.bsTitle;

      if (frame && baseUrl) {
        // ✅ 同じURLでも確実に再読込させるため cache-bust を付与
        const url = this.withCacheBust(baseUrl);
        // ✅ 属性としてセット（property ではなく）
        frame.setAttribute("src", url);
      }

      if (title) {
        const titleElement = this.element.querySelector(".modal-title");
        if (titleElement) titleElement.textContent = title;
      }
    };

    this.onHidden = () => {
      const frame = document.getElementById(this.frameIdValue);
      if (!frame) return;
      // ✅ 前回の中身を破棄
      frame.innerHTML = "";
      // ✅ 次回のために src 自体を外す（ここで固定URLを再セットしない）
      frame.removeAttribute("src");
      // （次に開くとき onShow で src を付け直し → 必ず最新を取得）
    };

    this.element.addEventListener("show.bs.modal", this.onShow);
    this.element.addEventListener("hidden.bs.modal", this.onHidden);
  }

  disconnect() {
    this.element.removeEventListener("show.bs.modal", this.onShow);
    this.element.removeEventListener("hidden.bs.modal", this.onHidden);
  }

  // 同一URLでも再取得させるためのクエリ付与（中間キャッシュ対策にも有効）
  withCacheBust(url) {
    try {
      const u = new URL(url, window.location.origin);
      u.searchParams.set("_", Date.now().toString());
      return u.toString();
    } catch {
      // 相対URLの簡易フォールバック
      const sep = url.includes("?") ? "&" : "?";
      return `${url}${sep}_=${Date.now()}`;
    }
  }
}
