// app/javascript/controllers/bs_modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: String }

  connect() {
    // デバッグ：まず動いてるか確認
    console.debug("[bs-modal] connect id=", this.idValue)

    if (!this.hasIdValue) return
    const el = document.getElementById(this.idValue)
    if (!el) { console.warn("[bs-modal] modal not found", this.idValue); return }

    const bs = window.bootstrap
    if (!bs?.Modal) {
      console.error("[bs-modal] window.bootstrap.Modal が見つかりません。bundle版読み込みを確認してください。")
      return
    }

    const modal = bs.Modal.getOrCreateInstance(el)

    // hidden 後のクリーンアップ（ここが重要）
    const onHidden = () => {
      // このdivを含む turbo-frame を空にして、次回に備える
      const frame = this.element.closest("turbo-frame")
      if (frame) frame.innerHTML = ""

      // 念のため保険で後片付け（競合時に backdrop/クラスが残る対策）
      document.body.classList.remove("modal-open")
      document.body.style.removeProperty("paddingRight")
      document.querySelectorAll(".modal-backdrop").forEach((e) => e.remove())

      el.removeEventListener("hidden.bs.modal", onHidden)
      console.debug("[bs-modal] cleaned")
    }
    el.addEventListener("hidden.bs.modal", onHidden, { once: true })

    // 実際に閉じる
    modal.hide()

    // 稀にトランジション競合で hidden が発火しない個体があるので保険
    setTimeout(() => {
      if (document.body.classList.contains("modal-open")) {
        console.warn("[bs-modal] hidden 取りこぼし検知 → 保険クリーンアップ発動")
        onHidden()
      }
    }, 300)
  }

  close() {
    const el = document.getElementById(this.idValue)
    const modal = window.bootstrap?.Modal?.getOrCreateInstance(el)
    if (modal) {
      modal.hide();
    } else {
      const frame = this.element.closest("turbo-frame")
      if (frame) frame.innerHTML = ""
      document.body.classList.remove("modal-open")
      document.body.style.removeProperty("paddingRight")
      document.querySelectorAll(".modal-backdrop").forEach((e) => e.remove())
    }
  }
}
