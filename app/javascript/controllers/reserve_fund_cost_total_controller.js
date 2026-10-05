import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cost", "total"]

  connect() {
    this.update()
  }

  update() {
    const total = this.costTargets.reduce((sum, field) => sum + (Number(field.value) || 0), 0)
    this.totalTarget.textContent = total.toLocaleString("ja-JP")
  }
}
