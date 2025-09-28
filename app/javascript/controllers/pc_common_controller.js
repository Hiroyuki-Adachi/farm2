import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  initialize() {
    this.handleBeforeCache = this.handleBeforeCache.bind(this)
    this.handleTurboLoad = this.handleTurboLoad.bind(this)
    this.handleTurboClick = this.handleTurboClick.bind(this)
    this.handleTurboLoading = this.handleTurboLoading.bind(this)
    this.handleTurboFrameLoad = this.handleTurboFrameLoad.bind(this)
    this.handleTurboBeforeFetchResponse = this.handleTurboBeforeFetchResponse.bind(this)
    this.handleTurboFetchRequestError = this.handleTurboFetchRequestError.bind(this)
  }

  connect() {
    Turbo.setConfirmMethod(this.confirm.bind(this))

    window.popupAlert = this.popupAlert.bind(this)
    window.popupConfirm = this.popupConfirm.bind(this)
    window.loadingStart = this.loadingStart.bind(this)
    window.loadingEnd = this.loadingEnd.bind(this)

    document.addEventListener("turbo:before-cache", this.handleBeforeCache)
    document.addEventListener("turbo:load", this.handleTurboLoad)
    document.addEventListener("turbo:click", this.handleTurboClick)
    document.addEventListener("turbo:loading", this.handleTurboLoading)
    document.addEventListener("turbo:frame-load", this.handleTurboFrameLoad)
    document.addEventListener("turbo:before-fetch-response", this.handleTurboBeforeFetchResponse)
    document.addEventListener("turbo:fetch-request-error", this.handleTurboFetchRequestError)

    this.handleTurboLoad()

    if (document.documentElement.getAttribute("data-bs-theme") === "auto") {
      this.applyThemePreference()
    }
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.handleBeforeCache)
    document.removeEventListener("turbo:load", this.handleTurboLoad)
    document.removeEventListener("turbo:click", this.handleTurboClick)
    document.removeEventListener("turbo:loading", this.handleTurboLoading)
    document.removeEventListener("turbo:frame-load", this.handleTurboFrameLoad)
    document.removeEventListener("turbo:before-fetch-response", this.handleTurboBeforeFetchResponse)
    document.removeEventListener("turbo:fetch-request-error", this.handleTurboFetchRequestError)

    Turbo.setConfirmMethod((message, element) => window.confirm(message))

    if (this.windowClickHandler) {
      window.removeEventListener("click", this.windowClickHandler)
      this.windowClickHandler = null
    }

    delete window.popupAlert
    delete window.popupConfirm
    delete window.loadingStart
    delete window.loadingEnd

    if (this.themeMediaQuery) {
      this.themeMediaQuery.removeEventListener("change", this.themeChangeListener)
    }
  }

  popupAlert(message) {
    const body = document.getElementById("popup_alert_message")
    const modalElement = document.getElementById("popup_alert")
    if (!body || !modalElement) return

    body.innerText = message
    const popupForm = bootstrap.Modal.getOrCreateInstance(modalElement)
    popupForm.show()
  }

  popupConfirm(message, callback) {
    const modalElement = document.getElementById("popup_confirm")
    const messageElement = document.getElementById("popup_confirm_message")
    const yesButton = document.getElementById("popup_confirm_yes")
    const noButton = document.getElementById("popup_confirm_no")
    if (!modalElement || !messageElement || !yesButton || !noButton) return

    messageElement.innerText = message
    const popupForm = bootstrap.Modal.getOrCreateInstance(modalElement)

    const yesHandler = () => {
      popupForm.hide()
      callback?.(true)
    }

    const noHandler = () => {
      popupForm.hide()
      callback?.(false)
    }

    yesButton.addEventListener("click", yesHandler, { once: true })
    noButton.addEventListener("click", noHandler, { once: true })

    popupForm.show()
  }

  confirm(message) {
    const modalElement = document.getElementById("popup_confirm")
    const messageElement = document.getElementById("popup_confirm_message")
    if (!modalElement || !messageElement) return Promise.resolve(false)

    messageElement.innerText = message
    const popupForm = bootstrap.Modal.getOrCreateInstance(modalElement)
    popupForm.show()

    return new Promise((resolve) => {
      popupForm._element
        .querySelectorAll(".confirm-button")
        .forEach((button) => {
          button.addEventListener(
            "click",
            () => {
              if (button.value === "true") {
                this.loadingStart("しばらくお待ちください")
              }
              resolve(button.value === "true")
              popupForm.hide()
            },
            { once: true }
          )
        })
    })
  }

  handleBeforeCache() {
    document.querySelectorAll(".modal.show").forEach((element) => {
      const instance = bootstrap.Modal.getInstance(element)
      if (instance) instance.hide()
    })
    document
      .querySelectorAll(".modal-backdrop, .offcanvas-backdrop")
      .forEach((backdrop) => backdrop.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("overflow")
    document.body.style.removeProperty("padding-right")
  }

  handleTurboLoad() {
    document
      .querySelectorAll(".modal-backdrop, .offcanvas-backdrop")
      .forEach((backdrop) => backdrop.remove())
    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("overflow")
    document.body.style.removeProperty("padding-right")

    this.highlightNavigation()
    this.setupNavbarInteractions()
    this.setupTableToggles()
    this.setupSidebarToggle()
    this.setupOffcanvasSidebar()
  }

  handleTurboClick(event) {
    const target = event.target
    if (target && target.dataset.wait) {
      this.loadingStart("しばらくお待ちください")
    }
  }

  handleTurboLoading() {
    this.loadingEnd()
  }

  handleTurboFrameLoad() {
    this.loadingEnd()
  }

  handleTurboBeforeFetchResponse() {
    this.loadingEnd()
  }

  handleTurboFetchRequestError() {
    this.loadingEnd()
  }

  loadingStart(message) {
    const messageElement = document.getElementById("loading_message")
    if (messageElement) {
      messageElement.innerText = message
    }
    const loadingElement = document.getElementById("loading")
    if (loadingElement) {
      loadingElement.classList.remove("d-none")
    }
  }

  loadingEnd() {
    const loadingElement = document.getElementById("loading")
    if (loadingElement) {
      loadingElement.classList.add("d-none")
    }
  }

  highlightNavigation() {
    const currentController = document.getElementById("current_controller")
    const currentAction = document.getElementById("current_action")
    const sidebars = document.querySelectorAll(".my-sidebar")

    const STICKY_NAVBAR_IDS = new Set(["navbar_daily"])

    const eachSidebarGroup = (callback) => {
      sidebars.forEach((sidebar) => {
        sidebar
          .querySelectorAll("div[aria-labelledby]")
          .forEach((div) => callback(div, sidebar))
      })
    }

    const hideAllNonStickyGroups = () => {
      eachSidebarGroup((div) => {
        const navId = div.getAttribute("aria-labelledby")
        if (!STICKY_NAVBAR_IDS.has(navId)) {
          div.style.display = "none"
        } else {
          div.style.display = "block"
        }
      })
    }

    const clearActiveOnLinks = () => {
      sidebars.forEach((sidebar) => {
        sidebar
          .querySelectorAll("a.dropdown-item.active")
          .forEach((link) => link.classList.remove("active"))
      })
    }

    hideAllNonStickyGroups()

    if (!currentController || !currentAction || sidebars.length === 0) {
      return
    }

    clearActiveOnLinks()

    let firstNavbarIdToShow = null

    sidebars.forEach((sidebar) => {
      const links = Array.from(
        sidebar.querySelectorAll(
          `a[data-app-controller="${currentController.value}"]`
        )
      )
      if (links.length === 0) return

      const picked = links.find((link) => {
        const { actions } = link.dataset
        if (!actions) return true
        try {
          const parsed = JSON.parse(actions)
          return parsed.includes(currentAction.value)
        } catch (error) {
          return false
        }
      })

      if (picked) {
        picked.classList.add("active")
        const navdiv = picked.closest("div[aria-labelledby]")
        if (navdiv) {
          const navId = navdiv.getAttribute("aria-labelledby")
          if (!navId) return
          if (!STICKY_NAVBAR_IDS.has(navId)) {
            navdiv.style.display = "block"
          }
          if (!firstNavbarIdToShow) {
            firstNavbarIdToShow = navId
          }
        }
      }
    })

    if (firstNavbarIdToShow) {
      document
        .querySelectorAll("#navbar_farm2 a.farm2-navi.active")
        .forEach((link) => link.classList.remove("active"))
      const label = document.getElementById(firstNavbarIdToShow)
      if (label) label.classList.add("active")
    }
  }

  setupNavbarInteractions() {
    const myMenu = document.getElementById("menu_dropdown")
    const sidebars = document.querySelectorAll(".my-sidebar")

    const showSidebarGroupByNavbarId = (navbarId) => {
      const STICKY_NAVBAR_IDS = new Set(["navbar_daily"])

      sidebars.forEach((sidebar) => {
        sidebar.querySelectorAll("div[aria-labelledby]").forEach((div) => {
          const navId = div.getAttribute("aria-labelledby")
          if (navId === navbarId || STICKY_NAVBAR_IDS.has(navId)) {
            div.style.display = "block"
          } else {
            div.style.display = "none"
          }
        })
      })

      document
        .querySelectorAll("#navbar_farm2 a.farm2-navi.active")
        .forEach((link) => link.classList.remove("active"))
      const label = document.getElementById(navbarId)
      if (label) label.classList.add("active")
    }

    document.querySelectorAll("#navbar_farm2 a.farm2-navi").forEach((link) => {
      if (link.dataset.pcCommonBound === "true") return
      link.dataset.pcCommonBound = "true"

      link.addEventListener("click", (event) => {
        const navbarId = event.currentTarget.id
        showSidebarGroupByNavbarId(navbarId)

        if (myMenu) {
          const source = document.querySelector(
            `div[aria-labelledby="${navbarId}"] div.navbar`
          )
          if (source) {
            myMenu.innerHTML = source.innerHTML
            myMenu.dataset.id = navbarId
            myMenu.style.display = "block"

            let left = 0
            let element = event.currentTarget
            while (element) {
              left += element.offsetLeft || 0
              element = element.offsetParent
            }
            myMenu.style.left = `${left}px`
          }
        }
        event.preventDefault()
        event.stopPropagation()
      })
    })

    if (!this.windowClickHandler) {
      this.windowClickHandler = (event) => {
        if (!event.target.matches(".nav-link") && myMenu) {
          myMenu.style.display = "none"
          event.stopPropagation()
        }
      }
      window.addEventListener("click", this.windowClickHandler)
    }
  }

  setupTableToggles() {
    document.querySelectorAll(".tr-total1").forEach((element) => {
      if (element.dataset.pcCommonBound === "true") return
      element.dataset.pcCommonBound = "true"

      element.addEventListener("click", (event) => {
        const totalTr = event.target.closest("tr")
        if (!totalTr) return
        const code1 = totalTr.dataset.code1
        const totalRows = document.querySelectorAll(
          `.tr-total2[data-code1="${code1}"]`
        )
        totalRows.forEach((row) => {
          row.style.display =
            row.style.display === "none" ? "table-row" : "none"
        })
        if (totalRows.length === 0) {
          document
            .querySelectorAll(`.tr-detail[data-code1="${code1}"]`)
            .forEach((row) => {
              row.style.display =
                row.style.display === "none" ? "table-row" : "none"
            })
        }
        document
          .querySelectorAll(`.tr-detail[data-code1="${code1}"]`)
          .forEach((row) => {
            const total2 = document.querySelector(
              `.tr-total2[data-code1="${row.dataset.code1}"][data-code2="${row.dataset.code2}"]`
            )
            if (total2 && total2.style.display === "none") {
              row.style.display = "none"
            }
          })
      })
    })

    document.querySelectorAll(".tr-total2").forEach((element) => {
      if (element.dataset.pcCommonBound === "true") return
      element.dataset.pcCommonBound = "true"

      element.addEventListener("click", (event) => {
        const totalTr = event.target.closest("tr")
        if (!totalTr) return
        const code1 = totalTr.dataset.code1
        const code2 = totalTr.dataset.code2
        document
          .querySelectorAll(
            `.tr-detail[data-code1="${code1}"][data-code2="${code2}"]`
          )
          .forEach((row) => {
            row.style.display =
              row.style.display === "none" ? "table-row" : "none"
          })
      })
    })

    document.querySelectorAll(".tr-total2, .tr-detail").forEach((element) => {
      element.style.display = "none"
    })
  }

  setupSidebarToggle() {
    const desktopSidebar = document.getElementById("sidebar_desktop")
    const contentCol = document.getElementById("content_col")
    const toggleBtn = document.getElementById("toggle_sidebar")
    const STORE_KEY = "farm2:sidebar_folded"

    const applySidebarState = (folded) => {
      if (!desktopSidebar || !contentCol) return

      if (folded) {
        desktopSidebar.classList.add("d-lg-none")
        desktopSidebar.classList.remove("d-lg-block")
        contentCol.classList.remove("col-lg-10")
        contentCol.classList.add("col-12")
        toggleBtn?.setAttribute("aria-pressed", "true")
        document.documentElement.classList.add("sidebar-collapsed")
      } else {
        desktopSidebar.classList.remove("d-lg-none")
        desktopSidebar.classList.add("d-lg-block")
        contentCol.classList.remove("col-12")
        contentCol.classList.add("col-lg-10")
        toggleBtn?.setAttribute("aria-pressed", "false")
        document.documentElement.classList.remove("sidebar-collapsed")
      }
    }

    applySidebarState(localStorage.getItem(STORE_KEY) === "1")

    if (toggleBtn && toggleBtn.dataset.pcCommonBound !== "true") {
      toggleBtn.dataset.pcCommonBound = "true"
      toggleBtn.addEventListener("click", () => {
        const next = !(localStorage.getItem(STORE_KEY) === "1")
        localStorage.setItem(STORE_KEY, next ? "1" : "0")
        applySidebarState(next)
      })
    }
  }

  setupOffcanvasSidebar() {
    const offcanvasEl = document.getElementById("sidebar_off_canvas")
    if (!offcanvasEl) return

    if (offcanvasEl.dataset.pcCommonShowBound !== "true") {
      offcanvasEl.dataset.pcCommonShowBound = "true"
      offcanvasEl.addEventListener("show.bs.offcanvas", () => {
        offcanvasEl
          .querySelectorAll(".my-sidebar div[aria-labelledby]")
          .forEach((div) => {
            div.style.display = "block"
          })
      })
    }

    if (offcanvasEl.dataset.pcCommonClickBound !== "true") {
      offcanvasEl.dataset.pcCommonClickBound = "true"
      offcanvasEl.addEventListener("click", (event) => {
        const link = event.target.closest("a")
        if (!link) return
        const inst = bootstrap.Offcanvas.getInstance(offcanvasEl)
        inst?.hide()
      })
    }
  }

  applyThemePreference() {
    this.themeMediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.themeChangeListener = () => {
      document.documentElement.setAttribute(
        "data-bs-theme",
        this.themeMediaQuery.matches ? "dark" : "light"
      )
    }

    this.themeMediaQuery.addEventListener("change", this.themeChangeListener)
    this.themeChangeListener()
  }
}
