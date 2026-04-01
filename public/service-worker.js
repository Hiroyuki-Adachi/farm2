self.addEventListener("push", (event) => {
  const payload = (() => {
    if (!event.data) {
      return { title: "作業予定のお知らせ", body: "新しい通知があります。", url: "/" };
    }

    try {
      return event.data.json();
    } catch (_error) {
      return { title: "作業予定のお知らせ", body: event.data.text(), url: "/" };
    }
  })();

  event.waitUntil(
    self.registration.showNotification(payload.title || "作業予定のお知らせ", {
      body: payload.body,
      data: { url: payload.url || "/" },
      tag: payload.tag,
      icon: payload.icon,
      badge: payload.badge || payload.icon
    })
  );
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const targetUrl = event.notification.data?.url || "/";

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url === targetUrl && "focus" in client) return client.focus();
      }

      if (clients.openWindow) return clients.openWindow(targetUrl);
      return null;
    })
  );
});
