import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  open(event) {
    event.preventDefault()
    const target = event.currentTarget
    const url = target?.dataset.url
    if (!url) return

    fetch(url, {
      headers: { Accept: "text/vnd.turbo-stream.html" },
      method: "GET"
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html))
  }
}
