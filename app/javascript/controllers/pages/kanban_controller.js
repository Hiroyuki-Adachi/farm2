// app/javascript/controllers/kanban_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["column"]
  static values = {
    updateUrl: String,
    csrfToken: String
  }

  connect() {
    this.sortables = this.columnTargets.map((column) => {
      return Sortable.create(column, {
        group: "tasks",
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
    const columnsPayload = this.columnTargets.map((column) => {
      const kanbanColumn = column.dataset.taskKanbanColumn
      const taskIds = Array.from(column.querySelectorAll("[data-task-id]"))
                           .map(el => el.dataset.taskId)
      return {
        task_kanban_column: kanbanColumn,
        task_ids: taskIds
      }
    })

    const body = JSON.stringify({ columns: columnsPayload })

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfTokenValue,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`Server error: ${response.status} ${response.statusText}`);
        }
        return response.text();
      })
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Kanban update error", error);
        window.popupAlert("カンバンボードの更新に失敗しました。再度お試しください。");
      })
  }
}
