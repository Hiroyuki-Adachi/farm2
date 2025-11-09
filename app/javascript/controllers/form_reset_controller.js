// app/javascript/controllers/form_reset_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.boundOnReset = this.onReset.bind(this);
    this.element.addEventListener("reset", this.boundOnReset);
  }

  disconnect() {
    this.element.removeEventListener("reset", this.boundOnReset);
  }

  onReset(event) {
    requestAnimationFrame(() => {
      this.element.querySelectorAll('input[type="hidden"]').forEach(hidden => {
        hidden.value = '';
      });
    });
  }
}
