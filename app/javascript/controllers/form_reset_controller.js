// app/javascript/controllers/form_reset_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("reset", this.onReset.bind(this));
  }

  disconnect() {
    this.element.removeEventListener("reset", this.onReset.bind(this));
  }

  onReset(event) {
    requestAnimationFrame(() => {
      this.element.querySelectorAll('input[type="hidden"]').forEach(hidden => {
        hidden.value = '';
      });
    });
  }
}
