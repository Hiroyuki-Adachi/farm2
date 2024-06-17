if ('serviceWorker' in navigator && 'PushManager' in window) {
    navigator.serviceWorker.register('/service-worker.js')
      .then(function(registration) {
        console.log('Service Worker registered with scope:', registration.scope);
        
        return registration.pushManager.getSubscription()
          .then(async function(subscription) {
            if (subscription) {
              return subscription;
            }
  
            const vapidPublicKey = 'Your VAPID Public Key'; // あなたのVAPID公開鍵をここに挿入してください
            const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);
  
            return registration.pushManager.subscribe({
              userVisibleOnly: true,
              applicationServerKey: convertedVapidKey
            });
          });
      })
      .then(function(subscription) {
        console.log('User is subscribed:', subscription);
      })
      .catch(function(error) {
        console.error('Service Worker registration or subscription failed:', error);
      });
  }
  
// VAPIDキーをBase64からUint8Arrayに変換する関数
function urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding)
      .replace(/-/g, '+')
      .replace(/_/g, '/');
  
    const rawData = window.atob(base64);
    const outputArray = new Uint8Array(rawData.length);
  
    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i);
    }
    return outputArray;
}
