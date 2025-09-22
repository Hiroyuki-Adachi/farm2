// app/javascript/controllers/inline_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]

  connect() {
    // 初期オートサイズ
    this.autosize()
    this.textareaTarget.focus()
    this.textareaTarget.setSelectionRange(this.textareaTarget.value.length, this.textareaTarget.value.length)
  }

  autosize() {
    const ta = this.textareaTarget
    ta.style.height = "auto"
    ta.style.height = `${ta.scrollHeight}px`
  }

  submit(event) {
    // Cmd/Ctrl+Enter
    this.element.requestSubmit()
  }

  cancel(event) {
    // Esc でキャンセルリンクをクリック扱いに
    const cancel = this.element.querySelector('a.btn-outline-secondary')
    if (cancel) cancel.click()
  }

  afterSubmit(e) {
    // 送信後の後処理が必要なら（今回は不要）
  }
}
