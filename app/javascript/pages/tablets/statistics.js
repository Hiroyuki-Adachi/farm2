import { init as initStatistics } from "pages/statistics";

export const init = () => {
  initStatistics();

  // 初期表示で1つ目のタブを自動読込して、タップ回数を減らす
  const firstTab = document.querySelector(".nav .nav-link");
  const hasActive = document.querySelector(".nav .nav-link.active");
  if (firstTab && !hasActive) firstTab.click();
};
