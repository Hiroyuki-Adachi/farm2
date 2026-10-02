import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  start(event) {
    if (this.submitting) {
      event.preventDefault()
      return
    }

    this.submitting = true
    this.submitter = event.submitter
    if (this.submitter) this.submitter.disabled = true
    window.loadingStart?.("登録中です。しばらくお待ちください")
  }

  // ブラウザーの「戻る」で復元されたフォームも再操作できるようにする。
  reset() {
    this.submitting = false
    if (this.submitter) this.submitter.disabled = false
    window.loadingEnd?.()
  }
}
