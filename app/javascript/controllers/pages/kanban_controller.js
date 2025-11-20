// app/javascript/controllers/kanban_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["column"]
  static values = {
    updateUrl: String,
    csrfToken: String
  }

  connect() {
    this.sortables = this.columnTargets.map((column) => {
      return Sortable.create(column, {
        group: "tasks",     // 列間移動を許可
        animation: 150,
        ghostClass: "opacity-50",
        onEnd: this.onEnd.bind(this)
      })
    })
  }

  disconnect() {
    if (this.sortables) {
      this.sortables.forEach(s => s.destroy())
    }
  }

  onEnd(event) {
    // ドロップのたびに、全列の state をサーバへ送る
    const columnsPayload = this.columnTargets.map((column) => {
      const taskIds = Array.from(column.querySelectorAll("[data-task-id]"))
                           .map(el => el.dataset.taskId)
      return {
        task_kanban_column: column.dataset.taskKanbanColumn,
        task_ids: taskIds
      }
    })

    const body = JSON.stringify({ columns: columnsPayload })

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfTokenValue
      },
      body
    }).then((response) => {
      if (!response.ok) {
        console.error("Kanban update failed", response.status)
      }
    }).catch((error) => {
      console.error("Kanban update error", error)
    })
  }
}
