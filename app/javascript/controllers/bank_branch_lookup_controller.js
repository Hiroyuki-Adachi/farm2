import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["bankCode", "branchCode"]
  static values = { url: String, debounce: { type: Number, default: 300 } }

  connect() {
    this._debouncedFetch = this._debounce(this._fetch.bind(this), this.debounceValue)
    if (this.bankCodeTarget.value) this._fetch()
  }

  disconnect() {
    this._abortController?.abort()
  }

  fetch = () => {
    this._debouncedFetch()
  }

  _fetch() {
    const params = new URLSearchParams({
      code: this.bankCodeTarget.value,
      branch_code: this.branchCodeTarget.value
    })

    this._abortController?.abort()
    this._abortController = new AbortController()

    fetch(`${this.urlValue}?${params}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" },
      signal: this._abortController.signal
    })
      .then(res => {
        const contentType = res.headers.get("Content-Type") || ""
        if (!res.ok || !contentType.includes("turbo-stream")) {
          throw new Error(`lookup request failed: ${res.status}`)
        }
        return res.text()
      })
      .then(html => Turbo.renderStreamMessage(html))
      .catch(e => { if (e.name !== "AbortError") console.error(e) })
  }

  _debounce(fn, wait) {
    let t = null
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), wait) }
  }
}
