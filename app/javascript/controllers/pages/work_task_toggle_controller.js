// app/javascript/controllers/pages/work_task_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["check", "close"]

  connect() {
    this.apply()
  }

  // 「着手」が切り替わったときに呼ぶ
  sync() {
    this.apply()
  }

  apply() {
    const started = this.checkTarget.checked
    if (started) {
      this.closeTarget.disabled = false
      // started が true のときは close は自由にチェック可（何もしない）
    } else {
      // started が false のときは close を外して無効化
      this.closeTarget.checked = false
      this.closeTarget.disabled = true
    }
  }
}
