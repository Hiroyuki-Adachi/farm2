import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["annualOnly", "monthlyOnly", "kindSelect"];

  connect() { this.toggle(); }
  change()  { this.toggle(); }

  toggle() {
    const kind = this.kindSelectTarget.value;

    if (kind === "annual") {
      this.showAnnual();
      this.hideMonthly();
    } else {
      this.hideAnnual();
      this.showMonthly();
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

  showMonthly() {
    this.monthlyOnlyTargets.forEach(element => {
      element.classList.remove("d-none");
    });
  }

  hideMonthly() {
    this.monthlyOnlyTargets.forEach(element => {
      element.classList.add("d-none");
    });
  }
}
