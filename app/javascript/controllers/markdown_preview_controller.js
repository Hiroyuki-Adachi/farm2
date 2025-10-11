import { Controller } from "@hotwired/stimulus"
import { marked } from "marked"
import DOMPurify from "dompurify"

export default class extends Controller {
  static targets = ["input", "preview", "counter"]

  connect() {
    // 好みでオプション
    marked.setOptions({ gfm: true, breaks: true })
    this.update()
  }

  update() {
    const raw = this.inputTarget.value || ""
    const dirty = marked.parse(raw)
    const clean = DOMPurify.sanitize(dirty, {
      ADD_TAGS: ['input'],
      ADD_ATTR: ['type','checked','disabled','value','class']
    })
    this.previewTarget.innerHTML = clean
    if (this.hasCounterTarget) this.counterTarget.textContent = `${raw.length} chars`
  }
}
