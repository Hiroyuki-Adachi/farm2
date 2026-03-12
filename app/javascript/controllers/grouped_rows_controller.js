import { Controller } from "@hotwired/stimulus"

// data-controller="grouped-rows" を付けた <table> 内で動作
export default class extends Controller {
  connect() {
    // 初期状態：明細と小計を隠す
    this.hideAll(".tr-detail, .tr-total2")

    // アクセシビリティ：行をボタンっぽく
    this.element.querySelectorAll(".tr-total1, .tr-total2").forEach(row => {
      if (!row.hasAttribute("tabindex")) row.tabIndex = 0
      row.setAttribute("role", "button")
      row.setAttribute("aria-expanded", "false")
    })
  }

  // 合計クリック：
  // - 小計が存在するグループ → 小計をトグル（明細は常に隠す）
  // - 小計が存在しないグループ → 明細をトグル（= tr-total2 のように動作）
  toggleTotal1(event) {
    const row  = event.currentTarget.closest("tr")
    const code1 = row?.dataset.code1
    if (!code1) return

    const subtotals = this.qsa(`.tr-total2[data-code1="${esc(code1)}"]`)

    if (subtotals.length > 0) {
      // 従来挙動（小計のトグル）
      const anyVisible = subtotals.some(el => !el.classList.contains("d-none"))
      if (anyVisible) {
        this.hideAll(subtotals)
        this.hideAll(this.qsa(`.tr-detail[data-code1="${esc(code1)}"]`))
        row.setAttribute("aria-expanded", "false")
      } else {
        this.showAll(subtotals)
        this.hideAll(this.qsa(`.tr-detail[data-code1="${esc(code1)}"]`))
        row.setAttribute("aria-expanded", "true")
      }
    } else {
      // 追加仕様：小計が無い → 明細をトグル
      const details = this.qsa(`.tr-detail[data-code1="${esc(code1)}"]`)
      const anyVisible = details.some(el => !el.classList.contains("d-none"))
      if (anyVisible) {
        this.hideAll(details)
        row.setAttribute("aria-expanded", "false")
      } else {
        this.showAll(details)
        row.setAttribute("aria-expanded", "true")
      }
    }
  }

  // 小計クリック：該当の明細だけトグル
  toggleTotal2(event) {
    const row = event.currentTarget.closest("tr")
    const { code1, code2 } = row?.dataset || {}
    if (!code1 || !code2) return

    const details = this.qsa(`.tr-detail[data-code1="${esc(code1)}"][data-code2="${esc(code2)}"]`)
    const anyVisible = details.some(el => !el.classList.contains("d-none"))

    if (anyVisible) {
      this.hideAll(details)
      row.setAttribute("aria-expanded", "false")
    } else {
      this.showAll(details)
      row.setAttribute("aria-expanded", "true")
    }
  }

  // Enter/Space でクリック同等に
  onKeydown(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault()
      const row = event.currentTarget
      if (row.classList.contains("tr-total1")) this.toggleTotal1(event)
      else if (row.classList.contains("tr-total2")) this.toggleTotal2(event)
    }
  }

  // ---- helpers ----
  qsa(selector) { return Array.from(this.element.querySelectorAll(selector)) }
  hideAll(nodesOrSelector) {
    const els = Array.isArray(nodesOrSelector) ? nodesOrSelector : this.qsa(nodesOrSelector)
    els.forEach(el => el.classList.add("d-none"))
  }
  showAll(nodesOrSelector) {
    const els = Array.isArray(nodesOrSelector) ? nodesOrSelector : this.qsa(nodesOrSelector)
    els.forEach(el => el.classList.remove("d-none"))
  }
}

// CSS セレクタ用エスケープ（CSS.escape が無い環境の簡易フォールバック）
function esc(s) {
  try { return CSS?.escape ? CSS.escape(String(s)) : String(s).replace(/"/g, '\\"') }
  catch { return String(s).replace(/"/g, '\\"') }
}
