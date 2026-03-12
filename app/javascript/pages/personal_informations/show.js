import { Turbo } from "@hotwired/turbo-rails";

export const init = () => {
  document.querySelectorAll("#personal_table tr").forEach((tr) => {
    tr.addEventListener("click", (event) => {
      // 行内のリンクやボタンが既に何かするなら邪魔しない
      if (event.defaultPrevented) return;
      const target = event.target;
      if (target.closest("a, button, [role='button'], [data-no-row-nav]")) return;

      const url = event.currentTarget.dataset.href; // ← これが一番確実
      if (url) {
        Turbo.visit(url);
      }
      // data-href が無い行は無視
    });
  });
};
