import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// app/javascript/controllers/gantt_controller.js
export default class extends Controller {
  static values = {
    updateUrl: String,
    csrfToken: String
  }
  static targets = ["cell"]

  connect() {
    this.isResizing = false
  }

  startResize(event) {
    event.preventDefault()

    const handle = event.currentTarget
    this.isResizing   = true
    this.resizeEdge   = handle.classList.contains("gantt-handle--start") ? "start" : "end"
    this.resizeTaskId = handle.dataset.taskId
    this.startDate    = handle.dataset.date
    this.currentDate  = this.startDate

    // window 全体で mousemove / mouseup を見る
    this._onMouseMove = this.onMouseMove.bind(this)
    this._onMouseUp   = this.onMouseUp.bind(this)
    window.addEventListener("mousemove", this._onMouseMove)
    window.addEventListener("mouseup", this._onMouseUp)
  }

  onMouseMove(event) {
    if (!this.isResizing) return

    // いまマウスが乗っているセルを探す
    const cell = event.target.closest("[data-pages--gantt-target='cell']")
    if (!cell) return
    if (cell.dataset.taskId !== this.resizeTaskId) return

    const date = cell.dataset.date
    if (!date || date === this.currentDate) return

    this.currentDate = date
    this.previewResize()
  }

  previewResize() {
    // ここで対象タスク行のセルに
    // "gantt-cell--bar", "gantt-cell--start", "gantt-cell--end"
    // をつけ直す（プレビュー用）
    // ※サーバにはまだ送らない
  }

  onMouseUp(event) {
    if (!this.isResizing) return

    this.isResizing = false
    window.removeEventListener("mousemove", this._onMouseMove)
    window.removeEventListener("mouseup", this._onMouseUp)

    // 最終的に止まった日付でサーバ更新
    this.sendResize()
  }

  sendResize() {
    const payload = {
      task_id: this.resizeTaskId,
      date: this.currentDate,
      edge: this.resizeEdge // "start" or "end"
    }

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfTokenValue,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify(payload)
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch(e => console.error("Gantt resize error", e))
  }
}
