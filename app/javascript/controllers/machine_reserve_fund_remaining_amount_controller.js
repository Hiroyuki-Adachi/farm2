import { Controller } from "@hotwired/stimulus"

// 開始年月から基準日(期首)までの経過月数をもとに、残額(初期値)の目安を計算してフォームへ反映する。
// 例: 総額2,000,000円/7年、開始2024-07-10、基準日2026-01-01 -> 経過19ヶ月 -> 残額1,547,619円
export default class extends Controller {
  static targets = ["startedOn", "totalAmount", "years", "remainingAmount"]
  static values = { referenceDate: String }

  calculate() {
    const startedOn = this.startedOnTarget.value
    const totalAmount = Number(this.totalAmountTarget.value)
    const years = Number(this.yearsTarget.value)
    if (!startedOn || !this.hasReferenceDateValue || !totalAmount || !years) return

    const start = new Date(startedOn)
    const reference = new Date(this.referenceDateValue)
    const monthsElapsed = (reference.getFullYear() - start.getFullYear()) * 12 +
      (reference.getMonth() - start.getMonth()) + 1
    const cappedMonths = Math.min(Math.max(monthsElapsed, 0), years * 12)
    const consumed = Math.round((totalAmount * cappedMonths) / (years * 12))

    this.remainingAmountTarget.value = totalAmount - consumed
  }
}
