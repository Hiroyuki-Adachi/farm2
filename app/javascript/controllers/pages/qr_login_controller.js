import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["qrcode", "status"]
  static values = { url: String }

  async generate() {
    try {
      this.statusTarget.textContent = "QRコードを生成しています..."

      const res = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "X-CSRF-Token": this.csrfToken(),
          "Accept": "application/json"
        }
      })

      if (!res.ok) {
        throw new Error("QR生成に失敗しました")
      }

      const data = await res.json()
      const token = data.token
      const expiresAt = data.expires_at

      // QR画像を表示
      this.qrcodeTarget.innerHTML = `
        <img src="${this.urlValue}/${token}/qrcode.svg"
             class="img-fluid"
             alt="QRコード">
      `

      this.statusTarget.textContent =
        `有効期限: ${this.formatTime(expiresAt)} まで`

      this.currentToken = token;

      this.subscription = consumer.subscriptions.create(
        { channel: "QrLoginChannel", token: token },
        {
          received: (data) => {
            console.log("QrLoginChannel Received data:", data);
            if (data.type === "approved") {
              this.consume();
            }
          }
        }
      )
    } catch (error) {
      console.error(error)
      this.statusTarget.textContent = "QR生成エラーが発生しました"
    }
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }

  formatTime(isoString) {
    const date = new Date(isoString)
    return date.toLocaleTimeString()
  }

  async consume() {
    if (!this.currentToken) return

    const res = await fetch(`${this.urlValue}/${this.currentToken}/consume`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.csrfToken(),
        "Accept": "application/json"
      }
    })

    const json = await res.json().catch(() => ({}))

    if (res.ok && json.action === "redirect") {
      if (this.subscription) {
        this.subscription.unsubscribe();
      }
      Turbo.visit(json.url)
    } else {
      this.statusTarget.textContent = json.message || "ログインに失敗しました"
    }
  }
}
