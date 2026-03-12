// app/javascript/controllers/pages/work_task_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["check", "close", "comment"]

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
      this.commentTarget.disabled = false
    } else {
      this.closeTarget.checked = false
      this.closeTarget.disabled = true
      this.commentTarget.disabled = true
      this.commentTarget.value = ""
    }
  }
}
