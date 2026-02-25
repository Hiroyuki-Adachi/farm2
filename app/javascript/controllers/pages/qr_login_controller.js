import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["qrcode", "status"]

  async generate() {
    try {
      this.statusTarget.textContent = "QRコードを生成しています..."

      const res = await fetch("/sessions/qr_login", {
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
        <img src="/sessions/qr_login/${token}/qrcode.svg"
             class="img-fluid"
             alt="QRコード">
      `

      this.statusTarget.textContent =
        `有効期限: ${this.formatTime(expiresAt)} まで`

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
}