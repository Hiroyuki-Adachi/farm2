import { Turbo } from "@hotwired/turbo-rails";
import "bootstrap";

window.popupAlert = (message) => {
    document.getElementById("popup_alert_message").innerText = message;
    const popupForm = new bootstrap.Modal(document.getElementById("popup_alert"));
    popupForm.show();
};

window.popupConfirm = (message, callback) => {
    document.getElementById("popup_confirm_message").innerText = message;
    const popupForm = new bootstrap.Modal(document.getElementById("popup_confirm"));
    document.getElementById("popup_confirm_yes").onclick = () => {
        popupForm.hide();
        callback(true);
    };
    document.getElementById("popup_confirm_no").onclick = () => {
        popupForm.hide();
        callback(false);
    };
    popupForm.show();
}

Turbo.setConfirmMethod((message, element) => {
    document.getElementById("popup_confirm_message").innerText = message;
    const popupForm = new bootstrap.Modal(document.getElementById("popup_confirm"));
    popupForm.show();

    return new Promise((resolve, reject) => {
        popupForm._element.querySelectorAll(".confirm-button").forEach((button) => {
            button.addEventListener("click", () => {
                if (button.value == "true") {
                    loadingStart("しばらくお待ちください");
                }
                resolve(button.value == "true");
                popupForm.hide();
            }, { once: true });
        });
    });
});


document.addEventListener("turbo:before-cache", () => {
  document.querySelectorAll(".modal.show").forEach(el => {
    const inst = bootstrap.Modal.getInstance(el);
    if (inst) inst.hide();
  })
  document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach(bd => bd.remove())
  document.body.classList.remove("modal-open");
  document.body.style.removeProperty("overflow");
  document.body.style.removeProperty("padding-right");
})

document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach(bd => bd.remove());
  document.body.classList.remove("modal-open");
  document.body.style.removeProperty("overflow");
  document.body.style.removeProperty("padding-right");
});

document.addEventListener('turbo:load', () => {
  // --- 残留掃除（既存のまま） ---
  document.querySelectorAll(".modal-backdrop, .offcanvas-backdrop").forEach((bd) => {bd.remove()});
  document.body.classList.remove("modal-open");
  document.body.style.removeProperty("overflow");
  document.body.style.removeProperty("padding-right");

  const currentController = document.getElementById("current_controller");
  const currentAction     = document.getElementById("current_action");
  const myMenu            = document.getElementById("menu_dropdown");

  // ★ モバイル/PC 両方のサイドバーが対象
  const sidebars = document.querySelectorAll(".my-sidebar");

  // ★ 常時表示したいグループ（=サイドバーの中の「日報管理」）
  //   ここを増やしたい場合は ID を追加するだけでOK
  const STICKY_NAVBAR_IDS = new Set(["navbar_daily"]);

  // ---- utils ----
  const eachSidebarGroup = (cb) => {
    sidebars.forEach(sb => {
      sb.querySelectorAll("div[aria-labelledby]").forEach(div => cb(div, sb));
    });
  };

  const hideAllNonStickyGroups = () => {
    eachSidebarGroup((div) => {
      const navId = div.getAttribute("aria-labelledby");
      if (!STICKY_NAVBAR_IDS.has(navId)) {
        div.style.display = "none";
      } else {
        // stickyは常時表示
        div.style.display = "block";
      }
    });
  };

  const showSidebarGroupByNavbarId = (navbarId) => {
    hideAllNonStickyGroups();
    if (!navbarId) return;
    sidebars.forEach(sb => {
      const group = sb.querySelector(`div[aria-labelledby="${navbarId}"]`);
      if (group) group.style.display = "block"; // stickyはすでにblock
    });
    // ナビゲーションの .active を整理
    document.querySelectorAll("#navbar_farm2 a.farm2-navi.active").forEach(a => a.classList.remove("active"));
    const label = document.getElementById(navbarId);
    if (label) label.classList.add("active");
  };

  const clearActiveOnLinks = () => {
    sidebars.forEach(sb => {
      sb.querySelectorAll("a.dropdown-item.active").forEach(a => a.classList.remove("active"));
    });
  };

  // controller/action による初期ハイライト
  const highlightByControllerAction = () => {
    if (!currentController || !currentAction || sidebars.length === 0) {
      // それでも sticky は常時表示
      hideAllNonStickyGroups();
      return;
    }
    const controllerValue = currentController.value;
    const actionValue     = currentAction.value;

    hideAllNonStickyGroups();
    clearActiveOnLinks();

    // どのグループを開くか（最初に見つけたものを代表に）
    let firstNavbarIdToShow = null;

    sidebars.forEach((sb) => {
      // 対象controllerのリンク候補
      const links = Array.from(sb.querySelectorAll(`a[data-controller="${controllerValue}"]`));
      if (links.length === 0) return;

      // actionsが一致するリンクを優先
      let picked = links.find(a => {
        try {
          const acts = a.dataset.actions ? JSON.parse(a.dataset.actions) : null;
          return !acts || acts.includes(actionValue);
        } catch(e) {
          return true; // 解析失敗時は許容
        }
      });

      
      if (picked) {
        picked.classList.add("active");
        const navdiv = picked.closest("div[aria-labelledby]");
        if (navdiv) {
          const navId = navdiv.getAttribute("aria-labelledby");
          if (!STICKY_NAVBAR_IDS.has(navId)) {
            navdiv.style.display = "block";
          }
          if (!firstNavbarIdToShow) firstNavbarIdToShow = navId;
        }
      }
    });

    // ナビの .active を整える（sticky優先ではなく、見つかったグループ基準）
    if (firstNavbarIdToShow) {
      document.querySelectorAll("#navbar_farm2 a.farm2-navi.active").forEach(a => a.classList.remove("active"));
      const label = document.getElementById(firstNavbarIdToShow);
      if (label) label.classList.add("active");
    }
  };

    // ---- 初期表示 ----
    highlightByControllerAction();

    // ---- ナビクリック → サイドバーの該当グループを開く + ドロップダウンにも表示 ----
    const navbarLinks = document.querySelectorAll("#navbar_farm2 a.farm2-navi");
    navbarLinks.forEach((link) => {
        link.addEventListener("click", (event) => {
            const navbarId = event.currentTarget.id;

            // 1) サイドバーを該当グループに切り替え（stickyは常に表示）
            showSidebarGroupByNavbarId(navbarId);

            // 2) ドロップダウンにも表示（従来機能）
            if (myMenu) {
                const src = document.querySelector(`div[aria-labelledby="${navbarId}"] div.navbar`);
                if (src) {
                    myMenu.innerHTML = src.innerHTML;
                    myMenu.dataset.id = navbarId;
                    myMenu.style.display = "block";

                    let left = 0, elm = event.currentTarget;
                    do { left += elm.offsetLeft || 0; elm = elm.offsetParent; } while (elm);
                    myMenu.style.left = left + "px";
                }
            }
            event.stopPropagation();
            event.preventDefault(); // href="#"のスクロール抑止
        });
    });

    window.addEventListener("click", (event) => {
        if (!event.target.matches('.nav-link') && myMenu) {
            myMenu.style.display = "none";
            event.stopPropagation();
        }
    });

    // === 既存のテーブル開閉/ローディング系ハンドラはこの下にそのまま ===
    Array.from(document.getElementsByClassName("tr-total1")).forEach((element) => {
        element.addEventListener("click", (event) => {
            const totalTr = event.target.closest("tr");
            document.querySelectorAll(`.tr-total2[data-code1="${totalTr.dataset.code1}"]`).forEach((tr) => {
                tr.style.display = (tr.style.display == "none") ? "table-row" : "none";
            });
            if (document.querySelectorAll(`.tr-total2[data-code1="${totalTr.dataset.code1}"]`).length == 0) {
                document.querySelectorAll(`.tr-detail[data-code1="${totalTr.dataset.code1}"]`).forEach((tr) => {
                    tr.style.display = (tr.style.display == "none") ? "table-row" : "none";
                });
            }
            document.querySelectorAll(`.tr-detail[data-code1="${totalTr.dataset.code1}"]`).forEach((tr) => {
                const total2 = document.querySelector(`.tr-total2[data-code1="${tr.dataset.code1}"][data-code2="${tr.dataset.code2}"]`);
                if ((total2 != null) && (total2.style.display == "none")) {
                    tr.style.display = "none";
                }
            });
        });
    });
    Array.from(document.getElementsByClassName("tr-total2")).forEach((element) => {
        element.addEventListener("click", (event) => {
            const totalTr = event.target.closest("tr");
            document.querySelectorAll(`.tr-detail[data-code1="${totalTr.dataset.code1}"][data-code2="${totalTr.dataset.code2}"]`).forEach((tr) => {
                tr.style.display = (tr.style.display == "none") ? "table-row" : "none";
            });
        });
    });

    document.querySelectorAll(".tr-total2, .tr-detail").forEach((element) => {
        element.style.display = "none";
    });

    window.addEventListener("turbo:click", (event) => {
        if (event.target.dataset.wait) {
            loadingStart("しばらくお待ちください");
        }
    });

    window.addEventListener("turbo:loading", () => {
        loadingEnd();
    });
    window.addEventListener("turbo:frame-load", () => {
        loadingEnd();
    });

  // PC幅のサイドバー折りたたみ
  const desktopSidebar = document.getElementById("sidebar_desktop");
  const contentCol     = document.getElementById("content_col");
  const toggleBtn      = document.getElementById("toggle_sidebar");
  const STORE_KEY      = "farm2:sidebar_folded";

  const applySidebarState = (folded) => {
    if (!desktopSidebar || !contentCol) return;

    if (folded) {
      // ★ PC幅で確実に消す
      desktopSidebar.classList.add("d-md-none");
      desktopSidebar.classList.remove("d-md-block");

      contentCol.classList.remove("col-md-9","col-xl-10");
      contentCol.classList.add("col-12");

      toggleBtn?.setAttribute("aria-pressed","true");
      document.documentElement.classList.add("sidebar-collapsed");
    } else {
      // ★ PC幅で表示に戻す
      desktopSidebar.classList.remove("d-md-none");
      desktopSidebar.classList.add("d-md-block");

      contentCol.classList.remove("col-12");
      contentCol.classList.add("col-md-9","col-xl-10");

      toggleBtn?.setAttribute("aria-pressed","false");
      document.documentElement.classList.remove("sidebar-collapsed");
    }
  };

  applySidebarState(localStorage.getItem(STORE_KEY) === "1");

  toggleBtn?.addEventListener("click", () => {
    const next = !(localStorage.getItem(STORE_KEY) === "1");
    localStorage.setItem(STORE_KEY, next ? "1" : "0");
    applySidebarState(next);
  });
});

// 既存 activeBar を .my-sidebar でも動くようにそのまま活用
function activeBar(element) {
  const navdiv = element.closest("div[aria-labelledby]");
  element.style.backgroundColor = "White";
  if (navdiv) {
    navdiv.style.display = "block";
    const label = document.getElementById(navdiv.getAttribute("aria-labelledby"));
    if (label) label.classList.add("active");
  }
}

// loadingStart / loadingEnd は既存のまま

function loadingStart(message) {
    if (document.getElementById("loading_message") != null) {
        document.getElementById("loading_message").innerText = message;
    }
    if (document.getElementById("loading") != null) {
        document.getElementById("loading").classList.remove("d-none");
    }
}

function loadingEnd() {
    if (document.getElementById("loading") != null) {
        document.getElementById("loading").classList.add("d-none");
    }
}

window.loadingStart = loadingStart;
window.loadingEnd = loadingEnd;
