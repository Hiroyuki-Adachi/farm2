const PERMISSION_MESSAGES = {
  default: "LINE未連携の場合、この端末で作業予定の通知を受け取れます。",
  granted: "この端末で作業予定の通知を受け取れます。",
  denied: "通知が拒否されています。ブラウザ設定から許可してください。",
  unsupported: "この端末ではブラウザ通知を利用できません。"
};

const alertClass = (permission) => {
  switch (permission) {
    case "granted":
      return "alert-success";
    case "denied":
      return "alert-warning";
    case "unsupported":
      return "alert-secondary";
    default:
      return "alert-secondary";
  }
};

const csrfToken = () => document.querySelector("meta[name='csrf-token']")?.content;

const urlBase64ToUint8Array = (base64String) => {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const rawData = window.atob(base64);
  return Uint8Array.from([...rawData].map((char) => char.charCodeAt(0)));
};

const jsonRequest = async (url, method, body = {}) => {
  const response = await fetch(url, {
    method,
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      "X-CSRF-Token": csrfToken()
    },
    body: JSON.stringify(body)
  });

  return response.ok;
};

const updatePanel = (panel, button, permission, message = null) => {
  panel.classList.remove("alert-success", "alert-warning", "alert-secondary");
  panel.classList.add(alertClass(permission));

  const status = panel.querySelector("[data-push-notification-status]");
  if (status) status.textContent = message || PERMISSION_MESSAGES[permission] || PERMISSION_MESSAGES.default;
  if (button) button.hidden = permission === "granted";
};

const supported = () => {
  return "Notification" in window && "serviceWorker" in navigator && "PushManager" in window;
};

const syncPermission = async (permissionUrl, permission) => {
  await jsonRequest(permissionUrl, "PATCH", { permission });
};

const subscribe = async ({ subscriptionUrl, serviceWorkerUrl, vapidPublicKey }) => {
  if (!vapidPublicKey) return false;

  const registration = await navigator.serviceWorker.register(serviceWorkerUrl);
  await navigator.serviceWorker.ready;

  let subscription = await registration.pushManager.getSubscription();
  if (!subscription) {
    subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(vapidPublicKey)
    });
  }

  const payload = subscription.toJSON();
  const expirationTime =
    payload.expirationTime != null ? new Date(payload.expirationTime).toISOString() : null;
  return jsonRequest(subscriptionUrl, "POST", {
    subscription: {
      endpoint: payload.endpoint,
      p256dh: payload.keys?.p256dh,
      auth: payload.keys?.auth,
      expiration_time: expirationTime,
      user_agent: navigator.userAgent
    }
  });
};

export const init = async ({ el }) => {
  const panel = el.querySelector("[data-push-notification-panel]");
  if (!panel) return;

  const button = panel.querySelector("[data-push-notification-enable]");
  const config = {
    permissionUrl: el.dataset.pushSubscriptionPermissionUrl,
    serviceWorkerUrl: el.dataset.pushSubscriptionServiceWorkerUrl,
    subscriptionUrl: el.dataset.pushSubscriptionUrl,
    vapidPublicKey: el.dataset.pushSubscriptionVapidPublicKey
  };

  if (!supported()) {
    await syncPermission(config.permissionUrl, "unsupported");
    updatePanel(panel, button, "unsupported");
    return;
  }

  const applyPermission = async (permission) => {
    if (permission === "granted") {
      const ok = await subscribe(config);
      updatePanel(panel, button, ok ? "granted" : "default", ok ? null : "通知登録に失敗しました。時間を置いて再度お試しください。");
      if (ok) await syncPermission(config.permissionUrl, "granted");
      return;
    }

    await syncPermission(config.permissionUrl, permission);
    updatePanel(panel, button, permission);
  };

  if (Notification.permission === "default") {
    const permission = await Notification.requestPermission().catch(() => "default");
    await applyPermission(permission);
  } else {
    await applyPermission(Notification.permission);
  }

  button?.addEventListener("click", async () => {
    const permission = Notification.permission === "granted" ? "granted" : await Notification.requestPermission().catch(() => "default");
    await applyPermission(permission);
  });
};
