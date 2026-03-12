// app/javascript/controllers/dependent_select_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    url: String,
    pathSelector: String,
    paramName: { type: String, default: "id" },
    extraParams: Object,
    method: { type: String, default: "GET" },
    initialLoad: { type: Boolean, default: false },
    debounce: { type: Number, default: 0 },
    clearOnEmpty: { type: Boolean, default: true },

    // ★ ラジオボタンの name（省略可。省略時は配下の最初のradioから自動検出）
    radioName: String
  }

  connect() {
    this._debouncedFetch = this.debounceValue > 0
      ? this._debounce(this._fetch.bind(this), this.debounceValue)
      : this._fetch.bind(this)

    if (this.initialLoadValue) this._fetch(this._currentValue())
  }

  // change->dependent-select#fetch （親select or 親ラジオ群の親要素に付ける）
  fetch = (event) => {
    const value = this._currentValue(event)
    if (!value && this.clearOnEmptyValue) { this._clearTarget(); return }
    this._debouncedFetch(value)
  }

  // ---- helpers ----
  _currentValue(event) {
    // 1) イベントがradioだったら event.target.value
    const t = event?.target
    if (t && t.matches && t.matches('input[type="radio"]')) return t.value

    // 2) 自要素が <select> なら value
    if (this.element.tagName === "SELECT") return this.element.value

    // 3) ラジオ群（親要素）として使う場合：name を決めて checked を読む
    const name = this.hasRadioNameValue ? this.radioNameValue : this._autoDetectRadioName()
    if (name) {
      const checked = this.element.querySelector(`input[type="radio"][name="${name}"]:checked`)
      if (checked) return checked.value
      return ""
    }

    // 4) それ以外は自要素の value を試みる
    return this.element.value ?? ""
  }

  _autoDetectRadioName() {
    const el = this.element.querySelector('input[type="radio"]')
    return el?.name
  }

  _fetch(parentValue) {
    const url = this._resolveUrl()
    const params = new URLSearchParams({
      [this.paramNameValue]: parentValue,
      ...(this.hasExtraParamsValue ? this.extraParamsValue : {})
    })

    const isGet = this.methodValue.toUpperCase() === "GET"
    const fetchUrl = isGet ? `${url}?${params}` : url
    const body = isGet ? undefined : params

    const headers = { Accept: "text/vnd.turbo-stream.html" }
    if (!isGet) headers["X-CSRF-Token"] = this._csrfToken()

    fetch(fetchUrl, { method: this.methodValue.toUpperCase(), headers, body })
      .then(res => res.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch(console.error)
  }

  _resolveUrl() {
    if (this.hasUrlValue) return this.urlValue
    if (this.hasPathSelectorValue) {
      const el = document.querySelector(this.pathSelectorValue)
      if (el?.value) return el.value
    }
    throw new Error("[dependent-select] url-value か path-selector-value が必要です。")
  }

  _clearTarget() {
    const next = this.element.nextElementSibling
    if (next && next.tagName === "SELECT") next.innerHTML = '<option value=""></option>'
  }

  _csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || ""
  }

  _debounce(fn, wait) {
    let t = null
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), wait) }
  }
}
