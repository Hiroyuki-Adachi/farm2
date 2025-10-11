# app/helpers/markdown_helper.rb
module MarkdownHelper
  # CommonMarker (github/commonmarker) / Commonmarker (kramdown/commonmarker) の両対応
  # Rouge と Nokogiri は Gem に入っている想定（Rails なら Nokogiri は Loofah 依存で入っています）
  require "nokogiri"
  require "rouge"

  # 一度だけ初期化して使い回す（軽い最適化）
  ROUGE_FORMATTER = Rouge::Formatters::HTMLLegacy.new

  # GFM で欲しい拡張を共通定義
  GFM_EXTENSIONS = %i[TABLE_PREFER_STYLE_ATTRIBUTES FOOTNOTES STRIKETHROUGH TASKLISTS AUTOLINK].freeze

  # 利用例: <%= markdown_to_html(task.description) %>
  def markdown_to_html(md)
    return "".html_safe if md.blank?

    html = render_markdown_core(md.to_s)

    # 生成 HTML のコードブロックを Rouge でハイライト
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    highlight_codeblocks!(frag)

    # a 要素の target / rel を補完（新規タブ&セキュア）
    decorate_links!(frag)
    decorate_tasklist_checkboxes!(frag)

    # 最後にサニタイズ（必要なタグ/属性だけ許可）
    sanitize(
      frag.to_html,
      tags: %w[
        p br strong em a code pre h1 h2 h3 h4 h5 h6 ul ol li blockquote table thead tbody tr th td hr img div span input
      ],
      attributes: %w[href title src alt class target rel type checked disabled value]
    )
  end

  private

  # --- Markdown → HTML のコア部（両実装に対応） ---
  def render_markdown_core(text)
    if defined?(CommonMarker)
      # github/commonmarker
      CommonMarker.render_html(
        text,
        [:DEFAULT, *GFM_EXTENSIONS],
        { unsafe: false } # スクリプト等は出さない
      )
    elsif defined?(Commonmarker)
      # kramdown/commonmarker
      Commonmarker.to_html(
        text,
        options: {
          parse: { smart: true },
          render: { unsafe: false },
          extensions: { table: true, footnotes: true, strikethrough: true, tasklist: true, autolink: true }
        }
      )
    else
      # どちらも入っていない場合のフォールバック（最小限）
      ERB::Util.h(text).gsub("\n", "<br>")
    end
  end

  # --- ```lang ...``` を Rouge でハイライト ---
  def highlight_codeblocks!(frag)
    frag.css("pre > code").each do |code|
      # 例: <code class="language-ruby"> を想定
      lang = code["class"].to_s[/\blanguage-([A-Za-z0-9_+-]+)/, 1]
      lexer = pick_lexer(lang, code.text)
      highlighted = ROUGE_FORMATTER.format(lexer.lex(code.text))
      code.parent.replace(%(<div class="highlight">#{highlighted}</div>))
    end
  end

  # 言語エイリアスも軽くケア（お好みで増やしてOK）
  def pick_lexer(lang, code)
    return Rouge::Lexers::PlainText if lang.blank?

    case lang.downcase
    when "rb"      then Rouge::Lexers::Ruby.new
    when "yml"     then Rouge::Lexers::YAML.new
    when "js"      then Rouge::Lexers::Javascript.new
    when "ts"      then Rouge::Lexers::TypeScript.new
    when "sh", "bash", "zsh" then Rouge::Lexers::Shell.new
    else
      Rouge::Lexer.find_fancy(lang, code) || Rouge::Lexers::PlainText.new
    end
  end

  # 外部リンクを新規タブ＋安全属性に（許可をつけてサニタイズで残す）
  def decorate_links!(frag)
    frag.css("a[href]").each do |a|
      a["target"] ||= "_blank"
      rel = (a["rel"].to_s.split(/\s+/) + %w[noopener noreferrer]).uniq
      a["rel"] = rel.join(" ")
    end
  end

  def decorate_tasklist_checkboxes!(frag)
    frag.css('input[type="checkbox"]').each do |i|
      i['disabled'] = 'disabled' # 読み取り専用に固定
    end
  end
end
