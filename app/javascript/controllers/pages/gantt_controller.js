import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["cell"]
  static values = {
    updateUrl: String,
    csrfToken: String
  }

  connect() {
    this.cellTargets.forEach((cell) => {
      cell.addEventListener("click", this.onCellClick.bind(this))
    })
  }

  disconnect() {
    this.cellTargets.forEach((cell) => {
      cell.removeEventListener("click", this.onCellClick.bind(this))
    })
  }

  onCellClick(event) {
    const cell = event.currentTarget
    const taskId = cell.dataset.taskId
    const date   = cell.dataset.date

    if (!taskId || !date) return

    // Shift押しながら → 開始日変更, 通常クリック → 終了日変更
    const edge = event.shiftKey ? "start" : "end"

    const payload = {
      task_id: taskId,
      date: date,
      edge: edge
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
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Gantt update error", error)
      })
  }
}
