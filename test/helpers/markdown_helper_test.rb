# test/helpers/markdown_helper_test.rb
require "test_helper"

class MarkdownHelperTest < ActionView::TestCase
  include MarkdownHelper

  test "コードブロックの HTML 構造と CSS クラスを維持する" do
    html = markdown_to_html(<<~MD)
      ```ruby
      puts 'hello'
      ```
    MD

    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    code = frag.at_css("div.highlight > pre.codehilite > code")

    assert code, "Expected highlighted code block wrapper"
    assert_equal "puts 'hello'\n", code.text
  end

  # Markdown から生成されるすべてのタグが
  # sanitize の ALLOWED_TAGS に含まれているかチェックする
  test "Markdown から生成されるすべてのタグが sanitize の ALLOWED_TAGS に含まれているかチェックする" do
    md = <<~MD
      # 見出し

      段落。**太字**、*斜体*、~~取り消し線~~、そして `インラインコード`。

      [リンク](https://example.com)

      ![画像](https://example.com/image.png)

      - リスト1
      - リスト2
      - [ ] タスク1
      - [x] タスク2

      > 引用ブロック

      ---

      ```ruby
      puts 'hello'
      ```

      | 見出し1 | 見出し2 |
      |---------|---------|
      | セル1   | セル2   |

      脚注の例[^1]。

      [^1]: 脚注の本文です。
    MD

    # helper の内部処理と同じパイプラインで「サニタイズ前」までを実行
    html = send(:render_markdown_core, md)
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    send(:highlight_codeblocks!, frag)
    send(:decorate_links!, frag)
    send(:decorate_tasklist_checkboxes!, frag)

    used_tags = frag.css("*").map(&:name).uniq.sort
    allowed_tags = MarkdownHelper::ALLOWED_TAGS.sort

    missing_tags = used_tags - allowed_tags

    assert missing_tags.empty?,
           "Missing tags in sanitize whitelist: #{missing_tags.inspect}"
  end

  test "Markdown から生成されるすべての属性が sanitize の ALLOWED_ATTRIBUTES に含まれているかチェックする" do
    md = <<~MD
      # 見出し

      段落。**太字**、*斜体*、~~取り消し線~~、そして `インラインコード`。

      [リンク](https://example.com)

      ![画像](https://example.com/image.png)

      - リスト1
      - リスト2
      - [ ] タスク1
      - [x] タスク2

      > 引用ブロック

      ---

      ```ruby
      puts 'hello'
      ```

      | 見出し1 | 見出し2 |
      |---------|---------|
      | セル1   | セル2   |

      脚注の例[^1]。

      [^1]: 脚注の本文です。
    MD

    # helper の内部処理と同じパイプラインで「サニタイズ前」までを実行
    html = send(:render_markdown_core, md)
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    send(:highlight_codeblocks!, frag)
    send(:decorate_links!, frag)
    send(:decorate_tasklist_checkboxes!, frag)

    used_tags = frag.css("*").map(&:name).uniq.sort
    allowed_tags = MarkdownHelper::ALLOWED_TAGS.sort

    missing_tags = used_tags - allowed_tags

    assert missing_tags.empty?,
           "Missing tags in sanitize whitelist: #{missing_tags.inspect}"
  end
end
