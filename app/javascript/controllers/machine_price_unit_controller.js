import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["unit", "price"]
  static values = { amount: Number }

  connect() {
    this.update()
  }

  update() {
    const direct = Number(this.unitTarget.value) === this.amountValue
    this.priceTarget.disabled = direct
    this.priceTarget.hidden = direct
    this.priceTarget.required = !direct
  }
}
