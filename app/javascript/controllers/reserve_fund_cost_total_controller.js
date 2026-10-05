import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cost", "total", "selection", "error", "status"]
  static values = { url: String }

  connect() {
    this.update()
    this.savedSelection = this.selectionTargets.map(field => field.checked)
  }

  update() {
    const total = this.costTargets.reduce((sum, field) => sum + (Number(field.value) || 0), 0)
    this.totalTarget.textContent = total.toLocaleString("ja-JP")
  }

  async reallocate() {
    if (this.saving) return
    this.saving = true
    const selected = this.selectionTargets.filter(field => field.checked).map(field => field.value)
    const controls = [...this.element.querySelectorAll("input, button")]
    const enabled = controls.filter(field => !field.disabled)
    enabled.forEach(field => { field.disabled = true })
    this.errorTarget.classList.add("d-none")
    this.statusTarget.textContent = "再按分中…"
    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || ""
        },
        body: JSON.stringify({ selected_work_type_ids: selected })
      })
      const result = await response.json()
      if (!Array.isArray(result.costs)) throw new Error("再按分に失敗しました。画面を再読み込みして確認してください。")
      result.costs.forEach(item => {
        const field = this.costTargets.find(target => target.dataset.workTypeId === String(item.work_type_id))
        const selection = this.selectionTargets.find(target => target.value === String(item.work_type_id))
        if (field) {
          field.value = item.cost
          field.readOnly = !item.allocation_enabled
        }
        if (selection) selection.checked = item.allocation_enabled
      })
      this.update()
      if (!response.ok) throw new Error(result.errors.join("\n"))
      this.savedSelection = this.selectionTargets.map(field => field.checked)
      this.statusTarget.textContent = "再按分しました。"
    } catch (error) {
      this.selectionTargets.forEach((field, index) => { field.checked = this.savedSelection[index] })
      this.statusTarget.textContent = ""
      this.errorTarget.textContent = error.message
      this.errorTarget.classList.remove("d-none")
    } finally {
      enabled.forEach(field => { field.disabled = false })
      this.saving = false
    }
  }
}
