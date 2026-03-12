import { Controller } from "@hotwired/stimulus"

// pages--template-picker
export default class extends Controller {
  open() {
    // ボタンで呼ぶ場合（data-action="click->pages--template-picker#open"）
    const modal = bootstrap.Modal.getOrCreateInstance(this.element);
    modal.show();
  }

  select(event) {
    const btn = event.currentTarget;
    // data-* からペイロードを組み立て
    const payload = {
      title:        btn.dataset.templateTitle || "",
      description:  btn.dataset.templateDescription || "",
      office_role:  btn.dataset.templateOfficeRole,
      priority:     btn.dataset.templatePriority,
      id:           btn.dataset.templateId
    };

    document.dispatchEvent(new CustomEvent("pages:template:selected", { detail: payload }));

    const modal = bootstrap.Modal.getInstance(this.element) || bootstrap.Modal.getOrCreateInstance(this.element);
    modal.hide();
  }
}
