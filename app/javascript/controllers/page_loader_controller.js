// app/javascript/controllers/page_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modules: String }

  async connect() {
    // DOMが落ち着くのを少し待つ（Turbo直後の競合回避）
    await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));

    const list = (this.modulesValue || "").split(/\s+/).filter(Boolean);
    for (const spec of list) await this.load(spec);
  }

  async load(spec) {
    try {
      const mod = await import(spec);

      // 優先順：default関数 → init関数 → setup関数 → windowグローバル(FooInit)
      const candidate =
        (typeof mod?.default === "function" && mod.default) ||
        (typeof mod?.init === "function"    && mod.init) ||
        (typeof mod?.setup === "function"   && mod.setup) ||
        (typeof window !== "undefined" && typeof window.FooInit === "function" && window.FooInit);

      if (candidate) {
        await candidate({ el: this.element, controller: this, root: this.element.ownerDocument });
      } else {
        // 何も暴露していない＝副作用型。ESMキャッシュで2回目以降は走らない点に注意
        // 必要なら「アダプタ」化（上記）してください。
        // console.warn(`[page-loader] ${spec} は実行用の関数をエクスポートしていません`);
      }
    } catch (e) {
      console.error(`[page-loader] failed: ${spec}`, e);
    }
  }
}
