import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["onlyAnnual", "onlyMonthly", "annualAndMonthly", "kindSelect"];

  connect() { this.toggle(); }
  change()  { this.toggle(); }

  toggle() {
    const kind = this.kindSelectTarget.value;

    switch (kind) {
      case "any_time":
        this.hideMonthly();
        this.hideAnnual();
        this.hideAnnualAndMonthly();
        break;
      case "annual":
        this.showAnnual();
        this.showAnnualAndMonthly();
        this.hideMonthly();
        break;
      case "monthly":
        this.hideAnnual();
        this.showAnnualAndMonthly();
        this.showMonthly();
        break;
      default:
        this.hideAnnual();
        this.hideMonthly();
        this.showAnnualAndMonthly();
        break;
    }
  }

  showAnnual() {
    this.onlyAnnualTargets.forEach(element => {
      element.classList.remove("d-none");
    });
    this.annualAndMonthlyTargets.forEach(element => {
      element.classList.remove("d-none");
    });
  }

  hideAnnual() {
    this.onlyAnnualTargets.forEach(element => {
      element.classList.add("d-none");
    });
  }

  showMonthly() {
    this.onlyMonthlyTargets.forEach(element => {
      element.classList.remove("d-none");
    });
  }

  hideMonthly() {
    this.onlyMonthlyTargets.forEach(element => {
      element.classList.add("d-none");
    });
  }

  showAnnualAndMonthly() {
    this.annualAndMonthlyTargets.forEach(element => {
      element.classList.remove("d-none");
    });
  }

  hideAnnualAndMonthly() {
    this.annualAndMonthlyTargets.forEach(element => {
      element.classList.add("d-none");
    });
  }
}
