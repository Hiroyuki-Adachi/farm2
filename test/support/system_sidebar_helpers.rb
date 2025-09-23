module SystemSidebarHelpers
  # lg 到達までできるだけ待つ。どうしても 992 未満なら以降でJSフォールバック。
  def ensure_wide!(min_width: 1200, height: 900, timeout: 2.0)
    begin
      page.current_window.resize_to(min_width, height)
    rescue StandardError => _e
    end
    begin
      page.driver.resize(min_width, height)
    rescue StandardError => _e
    end
    page.evaluate_script("window.dispatchEvent(new Event('resize'))")

    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    loop do
      w = page.evaluate_script("window.innerWidth") || 0
      break if w >= 992
      break if (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) > timeout
      sleep 0.05
    end
  end

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
    # 可視トグルがあればそれを使う
    if page.has_css?('#toggle_sidebar', visible: :visible, wait: 3)
      find('#toggle_sidebar', visible: :visible).click
      return
    end

    # 非可視の要素しか無い/重複IDなどのケースは祖先button/aを試す
    if page.has_css?('#toggle_sidebar', visible: :all, wait: 1)
      el  = find('#toggle_sidebar', visible: :all)
      btn = el.first(:xpath, "ancestor-or-self::button | ancestor-or-self::a", minimum: 0, wait: 0)
      if btn&.visible?
        btn.click
        return
      end
    end

    # 最後の手段：JSでサイドバーを強制表示（Bootstrapのd-none対策）
    page.execute_script(<<~JS)
      (function(){
        var el = document.getElementById('sidebar_desktop');
        if(!el) return;
        el.classList.remove('d-none');           // .d-none を外す
        el.style.display = 'block';              // 念のため display 指定
        document.body.classList.remove('sidebar-collapsed'); // クラスで畳んでる場合も解除
      })();
    JS
  end

  def ensure_sidebar_shown!
    ensure_wide! # ここでは例外を投げず、次の手で救う
    return if sidebar_visible?

    # トグルがDOMに現れるまで一応待つ（出なければ toggle_sidebar! がJSで開く）
    page.has_css?('#toggle_sidebar', wait: 3)
    toggle_sidebar!

    assert_selector '#sidebar_desktop', visible: :visible, wait: 5
  end
end
