// app/javascript/controllers/pc_common_controller.js
import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"
import "bootstrap" // importmap の "bootstrap.bundle.min.js" を pin 済みならこれでOK

export default class extends Controller {
  static inited = false // Turbo.setConfirmMethod を多重設定しないためのガード

  connect() {
    // ---- グローバル関数（window.*）を提供 ----
    if (!window.loadingStart) {
      window.loadingStart = function(message) {
        const msg = document.getElementById("loading_message");
        if (msg) msg.innerText = message ?? "";
        const el = document.getElementById("loading");
        el?.classList.remove("d-none");
      }
    }
    if (!window.loadingEnd) {
      window.loadingEnd = function() {
        const el = document.getElementById("loading");
        el?.classList.add("d-none");
      }
    }

    // bootstrap は bundle で window.bootstrap にぶら下がります
    const bootstrap = window.bootstrap

    window.popupAlert = (message) => {
      const msg = document.getElementById("popup_alert_message")
      const modalEl = document.getElementById("popup_alert")
      if (!msg || !modalEl) return
      msg.innerText = message
      const modal = new bootstrap.Modal(modalEl)
      modal.show()
    }

    window.popupConfirm = (message, callback) => {
      const msg = document.getElementById("popup_confirm_message")
      const modalEl = document.getElementById("popup_confirm")
      if (!msg || !modalEl) { callback?.(false); return }
      msg.innerText = message
      const modal = new bootstrap.Modal(modalEl)

      // 一度きり
      const yes = document.getElementById("popup_confirm_yes")
      const no  = document.getElementById("popup_confirm_no")
      yes?.addEventListener("click", () => { modal.hide(); callback?.(true) }, { once:true })
      no ?.addEventListener("click", () => { modal.hide(); callback?.(false)}, { once:true })
      modal.show()
    }

    // Turbo.confirm の上書き（アプリ全体に一度だけ）
    if (!this.constructor.inited) {
      this.constructor.inited = true
      Turbo.setConfirmMethod((message) => {
        const bootstrap = window.bootstrap
        const msg = document.getElementById("popup_confirm_message")
        const modalEl = document.getElementById("popup_confirm")
        if (!msg || !modalEl) return Promise.resolve(confirm(message))

        msg.innerText = message
        const modal = new bootstrap.Modal(modalEl)
        modal.show()

        return new Promise((resolve) => {
          modalEl.querySelectorAll(".confirm-button").forEach((btn) => {
            btn.addEventListener("click", () => {
              if (btn.value === "true") {
                window.loadingStart?.("しばらくお待ちください")
              }
              resolve(btn.value === "true")
              modal.hide()
            }, { once:true })
          })
        })
      })

      // Turbo ローディングの共通ハンドラ
      document.addEventListener("turbo:click", (e) => {
        if (e.target?.dataset?.wait) window.loadingStart?.("しばらくお待ちください")
      })
      document.addEventListener("turbo:loading", () => window.loadingEnd?.())
      document.addEventListener("turbo:frame-load", () => window.loadingEnd?.())
      document.addEventListener("turbo:before-fetch-response", () => window.loadingEnd?.())
      document.addEventListener("turbo:fetch-request-error", () => window.loadingEnd?.())
    }

    // before-cache の掃除（モーダルの残骸除去）
    this.beforeCacheHandler ||= () => {
      document.querySelectorAll(".modal.show").forEach(el => {
        const inst = window.bootstrap?.Modal.getInstance(el)
        if (inst) inst.hide()
      })
      document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach(bd => bd.remove())
      document.body.classList.remove("modal-open")
      document.body.style.removeProperty("overflow")
      document.body.style.removeProperty("padding-right")
    }
    document.addEventListener("turbo:before-cache", this.beforeCacheHandler, { once:false })

    // ---- あなたの init() の本体を実行（1ページ1回だけ）----
    // 画面ごとに複数の pc-common が同時に走らないように簡易ロック
    if (!document.documentElement.dataset.pcCommonInited) {
      document.documentElement.dataset.pcCommonInited = "1"
      this.initPcCommon()
    }
  }

  disconnect() {
    // ページ離脱時にロック解除（戻るキャッシュからの復帰を考慮）
    delete document.documentElement.dataset.pcCommonInited
    if (this.beforeCacheHandler) {
      document.removeEventListener("turbo:before-cache", this.beforeCacheHandler)
    }
  }

  // ===== ここに “元 pc-common.js の init()” 相当を移植 =====
  initPcCommon() {
    // 既存の掃除
    document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach(bd => bd.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("overflow")
    document.body.style.removeProperty("padding-right")

    const myMenu = document.getElementById("menu_dropdown")
    const sidebars = document.querySelectorAll(".my-sidebar")
    const STICKY_NAVBAR_IDS = new Set(["navbar_daily"])

    const eachSidebarGroup = (cb) => {
      sidebars.forEach(sb => {
        sb.querySelectorAll("div[aria-labelledby]").forEach(div => cb(div, sb))
      })
    }
    const hideAllNonStickyGroups = () => {
      eachSidebarGroup((div) => {
        const navId = div.getAttribute("aria-labelledby")
        div.style.display = STICKY_NAVBAR_IDS.has(navId) ? "block" : "none"
      })
    }
    const showSidebarGroupByNavbarId = (navbarId) => {
      hideAllNonStickyGroups()
      if (!navbarId) return
      sidebars.forEach(sb => {
        const group = sb.querySelector(`div[aria-labelledby="${navbarId}"]`)
        if (group) group.style.display = "block"
      })
      document.querySelectorAll("#navbar_farm2 a.farm2-navi.active").forEach(a => a.classList.remove("active"))
      const label = document.getElementById(navbarId)
      if (label) label.classList.add("active")
    }
    const clearActiveOnLinks = () => {
      sidebars.forEach(sb => {
        sb.querySelectorAll("a.dropdown-item.active").forEach(a => a.classList.remove("active"))
      })
    }
    const highlightByControllerAction = () => {
      const currentController = document.getElementById("current_controller")
      const currentAction     = document.getElementById("current_action")
      if (!currentController || !currentAction || sidebars.length === 0) {
        hideAllNonStickyGroups()
        return
      }
      const controllerValue = currentController.value
      const actionValue     = currentAction.value

      hideAllNonStickyGroups()
      clearActiveOnLinks()

      let firstNavbarIdToShow = null
      sidebars.forEach((sb) => {
        const links = Array.from(sb.querySelectorAll(`a[data-app-controller="${controllerValue}"]`))
        if (links.length === 0) return
        let picked = links.find(a => {
          try {
            const acts = a.dataset.actions ? JSON.parse(a.dataset.actions) : null
            return !acts || acts.includes(actionValue)
          } catch { return false }
        })
        if (picked) {
          picked.classList.add("active")
          const navdiv = picked.closest("div[aria-labelledby]")
          if (navdiv) {
            const navId = navdiv.getAttribute("aria-labelledby")
            if (!STICKY_NAVBAR_IDS.has(navId)) navdiv.style.display = "block"
            if (!firstNavbarIdToShow) firstNavbarIdToShow = navId
          }
        }
      })

      if (firstNavbarIdToShow) {
        document.querySelectorAll("#navbar_farm2 a.farm2-navi.active").forEach(a => a.classList.remove("active"))
        const label = document.getElementById(firstNavbarIdToShow)
        if (label) label.classList.add("active")
      }
    }

    // 初期表示
    highlightByControllerAction()

    // ナビクリックで表示切替＋ドロップダウン表示
    document.querySelectorAll("#navbar_farm2 a.farm2-navi").forEach((link) => {
      link.addEventListener("click", (event) => {
        const navbarId = event.currentTarget.id
        showSidebarGroupByNavbarId(navbarId)

        if (myMenu) {
          const src = document.querySelector(`div[aria-labelledby="${navbarId}"] div.navbar`)
          if (src) {
            myMenu.innerHTML = src.innerHTML
            myMenu.dataset.id = navbarId
            myMenu.style.display = "block"

            let left = 0, elm = event.currentTarget
            do { left += elm.offsetLeft || 0; elm = elm.offsetParent } while (elm)
            myMenu.style.left = left + "px"
          }
        }
        event.stopPropagation()
        event.preventDefault()
      })
    })

    window.addEventListener("click", (event) => {
      if (!event.target.matches(".nav-link") && myMenu) {
        myMenu.style.display = "none"
        event.stopPropagation()
      }
    })

    // サイドバー折り畳み（既存ロジックをそのまま）
    const desktopSidebar = document.getElementById("sidebar_desktop")
    const contentCol     = document.getElementById("content_col")
    const toggleBtn      = document.getElementById("toggle_sidebar")
    const STORE_KEY      = "farm2:sidebar_folded"
    const applySidebarState = (folded) => {
      if (!desktopSidebar || !contentCol) return
      if (folded) {
        desktopSidebar.classList.add("d-lg-none")
        desktopSidebar.classList.remove("d-lg-block")
        contentCol.classList.remove("col-lg-10")
        contentCol.classList.add("col-12")
        toggleBtn?.setAttribute("aria-pressed","true")
        document.documentElement.classList.add("sidebar-collapsed")
      } else {
        desktopSidebar.classList.remove("d-lg-none")
        desktopSidebar.classList.add("d-lg-block")
        contentCol.classList.remove("col-12")
        contentCol.classList.add("col-lg-10")
        toggleBtn?.setAttribute("aria-pressed","false")
        document.documentElement.classList.remove("sidebar-collapsed")
      }
    }
    applySidebarState(localStorage.getItem(STORE_KEY) === "1")
    toggleBtn?.addEventListener("click", () => {
      const next = !(localStorage.getItem(STORE_KEY) === "1")
      localStorage.setItem(STORE_KEY, next ? "1" : "0")
      applySidebarState(next)
    })

    // Offcanvas 連動
    const offcanvasEl = document.getElementById("sidebar_off_canvas")
    if (offcanvasEl) {
      offcanvasEl.addEventListener("show.bs.offcanvas", () => {
        offcanvasEl
          .querySelectorAll(".my-sidebar div[aria-labelledby]")
          .forEach(div => { div.style.display = "block" })
      })
      offcanvasEl.addEventListener("click", (e) => {
        const a = e.target.closest("a")
        if (!a) return
        const inst = window.bootstrap?.Offcanvas.getInstance(offcanvasEl)
        inst?.hide()
      })
    }

    // テーマ自動
    ;(() => {
      const root = document.documentElement
      if (root.getAttribute("data-bs-theme") !== "auto") return
      const mq = window.matchMedia("(prefers-color-scheme: dark)")
      const apply = () => root.setAttribute("data-bs-theme", mq.matches ? "dark" : "light")
      mq.addEventListener ? mq.addEventListener("change", apply) : mq.addListener(apply)
      apply()
    })()
  }
}
