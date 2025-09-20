import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["annualOnly", "kindSelect"];

  connect() { this.toggle(); }
  change()  { this.toggle(); }

  toggle() {
    const kind = this.kindSelectTarget.value;

    if (kind === "annual") {
      this.showAnnual();
    } else {
      this.hideAnnual();
    }
  }

  showAnnual() {
    this.annualOnlyTargets.forEach(element => {
      element.classList.remove("d-none");
    });
  }

  hideAnnual() {
    this.annualOnlyTargets.forEach(element => {
      element.classList.add("d-none");
    });
  }
}
