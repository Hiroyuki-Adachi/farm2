import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "status"]

  async generate() {
    this.setStatus("QRを生成しています…")

    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
      const response = await fetch("/qr_login_sessions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({})
      })

      if (!response.ok) throw new Error("QRセッションの作成に失敗しました")

      const data = await response.json()
      this.imageTarget.src = `/qr_login_sessions/${data.token}/qrcode.svg`
      this.imageTarget.hidden = false
      this.setStatus(`有効期限: ${new Date(data.expires_at).toLocaleString("ja-JP")}`)
    } catch (error) {
      this.setStatus(error.message)
    }
  }

  setStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message
  }
}
