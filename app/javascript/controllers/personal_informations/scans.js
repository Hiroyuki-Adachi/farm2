// app/javascript/controllers/personal_informations/scans.js
import QrScanner from "qr-scanner";
import "bootstrap";

document.addEventListener('turbo:load', () => {
  const video = document.getElementById("video");
  const resultBox = document.getElementById("result-box");
  const resultText = document.getElementById("qr-result");
  if (!video) return;

  let posting = false;
  let lastText = null;

  const scanner = new QrScanner(
    video,
    onScan,
    {
      preferredCamera: 'environment',
      highlightScanRegion: true,
      highlightCodeOutline: true,
      maxScansPerSecond: 8,
    }
  );

  scanner.start().catch(err => {
    console.error("camera start failed:", err);
    // iOSはhttps必須
  });

  async function onScan(result) {
    const text = typeof result === 'string' ? result : result?.data;
    if (!text || posting) return;
    if (text === lastText) return; // 同一内容を連続で拾った場合の暴発抑止
    lastText = text;

    // 結果の一時表示（任意）
    if (resultBox && resultText) {
      resultBox.classList.remove("d-none");
      resultText.textContent = text;
    }

    // JSON & type キーを満たす場合のみサーバへ

    let data = null;
    console.log("scanning data:", text);
    try { data = JSON.parse(text); } catch(e) { 
      console.log(e.message); 
      toast("QRコードの内容が不正です");
      return; 
    }
    if (!data || typeof data !== 'object' || !('type' in data)) return;

    posting = true;
    try {
      const res = await fetch(document.getElementById("scan_path").value, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({ payload: text })
      });

      if (res.ok) {
        const json = await res.json();
        // 成功 → スキャン停止して遷移
        await scanner.stop();
        video.srcObject?.getTracks().forEach(t => t.stop());
        video.srcObject = null;
        if (json?.redirect_url) {
          Turbo.visit(json.redirect_url);
        } else {
          // URLが無い場合はフルリロードのフォールバック
          window.location.reload();
        }
      } else {
        // 4xx → エラー表示してスキャン続行
        const err = await safeJson(res);
        console.warn("scan rejected:", err);
        toast(err?.message || "読み取り内容が不正です");
        posting = false;
      }
    } catch (e) {
      console.error("scan post failed:", e);
      posting = false; // 通信失敗でも継続可能に
    }
  }

  // Turboのキャッシュ前にクリーンアップ
  document.addEventListener('turbo:before-cache', () => {
    scanner.stop();
    video.srcObject?.getTracks().forEach(t => t.stop());
    video.srcObject = null;
  }, { once: true });

  async function safeJson(res) {
    try { return await res.json(); } catch { return null; }
  }

  function toast(msg) {
    document.getElementById("popup_alert_message").innerText = msg;
    const popupForm = new bootstrap.Modal(document.getElementById("popup_alert"));
    popupForm.show();

    console.log("[toast]", msg);
  }
});
