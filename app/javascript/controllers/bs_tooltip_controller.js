import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((el) => {
            new window.bootstrap.Tooltip(el);
        });
    }
}
