import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["bankCode", "branchCode"]
  static values = { url: String, debounce: { type: Number, default: 300 } }

  connect() {
    this._debouncedFetch = this._debounce(this._fetch.bind(this), this.debounceValue)
    this._fetch()
  }

  fetch = () => {
    this._debouncedFetch()
  }

  _fetch() {
    const params = new URLSearchParams({
      code: this.bankCodeTarget.value,
      branch_code: this.branchCodeTarget.value
    })

    fetch(`${this.urlValue}?${params}`, { headers: { Accept: "text/vnd.turbo-stream.html" } })
      .then(res => res.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch(console.error)
  }

  _debounce(fn, wait) {
    let t = null
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), wait) }
  }
}
