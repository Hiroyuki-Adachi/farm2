// app/javascript/controllers/wcs_filters_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wcs-filters"
export default class extends Controller {
  connect() {
    // 初期表示時にも一度反映しておきたければ
    this.apply()
  }

  apply() {
    // 上部フィルタの選択されている値を取得
    const selectedWorkTypeIds = Array.from(
      this.element.querySelectorAll(".work-type-filter:checked")
    ).map((cb) => cb.dataset.workTypeId)

    const selectedMonths = Array.from(
      this.element.querySelectorAll(".worked-month-filter:checked")
    ).map((cb) => cb.dataset.ym)

    const rowCheckboxes = this.element.querySelectorAll(".wcs-row-checkbox")

    rowCheckboxes.forEach((cb) => {
      const wtId = cb.dataset.workTypeId
      const month = cb.dataset.workedMonth

      // フィルタが空なら「その条件は絞り込み無し」と解釈
      const matchWorkType = selectedWorkTypeIds.includes(wtId)
      const matchMonth = selectedMonths.includes(month)

      cb.checked = matchWorkType && matchMonth
    })
  }
}
