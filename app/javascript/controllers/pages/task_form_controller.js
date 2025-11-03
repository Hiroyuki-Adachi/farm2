import { Controller } from "@hotwired/stimulus"

// pages--task-form
export default class extends Controller {
  static targets = [
    "titleField",
    "descriptionField",
    "officeRoleField",
    "priorityField",
    "idField"
  ];

  connect() {
    // モーダルから届くイベントを購読
    this._onTemplateSelected = (e) => this.applyTemplate(e.detail);
    document.addEventListener("pages:template:selected", this._onTemplateSelected);
  }

  disconnect() {
    document.removeEventListener("pages:template:selected", this._onTemplateSelected);
  }

  applyTemplate(t) {
    // 値を流し込み
    if (this.hasTitleFieldTarget)       this.titleFieldTarget.value       = t.title || "";
    if (this.hasDescriptionFieldTarget) this.descriptionFieldTarget.value = t.description || "";
    if (this.hasOfficeRoleFieldTarget && t.office_role) this.officeRoleFieldTarget.value = t.office_role;
    if (this.hasPriorityFieldTarget && t.priority)      this.priorityFieldTarget.value   = t.priority;
    if (this.hasIdFieldTarget && t.id)                  this.idFieldTarget.value         = t.id;

    // Markdownプレビュー更新（inputイベントで連携）
    if (this.hasDescriptionFieldTarget) {
      this.descriptionFieldTarget.dispatchEvent(new Event("input", { bubbles: true }));
    }

    // フォーカス（お好みで）
    if (this.hasTitleFieldTarget) this.titleFieldTarget.focus();
  }
}
