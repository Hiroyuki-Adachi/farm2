# test/application_system_test_case.rb など
module SystemSidebarHelpers
  # 既にお持ちっぽいけど一応
  def ensure_wide!(min_width: 1200, height: 900)
    page.driver.resize(min_width, height)
    page.evaluate_script("window.dispatchEvent(new Event('resize'))")
  end

  # “見えているか” を計算済スタイルで判定（Bootstrapのd-*-none対応）
  def sidebar_visible?
    page.evaluate_script(<<~JS)
      (function(){
        var el = document.getElementById('sidebar_desktop');
        if(!el) return false;
        var s = window.getComputedStyle(el);
        return !(s.display === 'none' || s.visibility === 'hidden' || s.opacity === '0');
      })();
    JS
  end

  def toggle_sidebar!
    find('#toggle_sidebar', visible: :all).click
  end

  # “見えてなければ押して見えるまで待つ”
  def ensure_sidebar_shown!
    ensure_wide!
    return if sidebar_visible?

    toggle_sidebar!
    # 画面更新/アニメーションを待つ（Capybaraの待機つき）
    expect(page).to have_css('#sidebar_desktop', visible: :visible)
  end

  # 再現性を高めたいとき：ローカルストレージで “閉じた状態” を作る
  # ※ STORE_KEY は実アプリのキー名に置き換えてください
  def force_sidebar_collapsed_via_local_storage!(store_key: 'sidebar.folded')
    page.execute_script("localStorage.setItem('#{store_key}', '1')")
    visit current_url # 反映のためリロード
  end
end
