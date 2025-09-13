# app/helpers/markdown_helper.rb
module MarkdownHelper
  require "commonmarker"
  require "rouge"
  # Nokogiri は Rails(Loofah) 依存で入っています

  def markdown_to_html(md)
    return "" if md.blank?

    # CommonMarker / Commonmarker どちらでも動くように
    html =
      if defined?(CommonMarker)
        CommonMarker.render_html(
          md.to_s,
          %i[DEFAULT TABLE_PREFER_STYLE_ATTRIBUTES FOOTNOTES STRIKETHROUGH TASKLISTS AUTOLINK],
          { unsafe: false }
        )
      else
        Commonmarker.to_html(
          md.to_s,
          options: {
            parse:  { smart: true },
            render: { unsafe: false },
            extensions: { table: true, footnotes: true, strikethrough: true, tasklist: true, autolink: true }
          }
        )
      end

    # 生成HTMLのコードブロックを Rouge でハイライト
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    frag.css("pre > code").each do |code|
      # <code class="language-ruby"> を想定
      lang = code["class"].to_s[/\blanguage-([A-Za-z0-9_+\-]+)/, 1]
      lexer = Rouge::Lexer.find_fancy(lang || "plaintext", code.text) || Rouge::Lexers::PlainText
      formatter = Rouge::Formatters::HTMLLegacy.new
      highlighted = formatter.format(lexer.lex(code.text))
      code.parent.replace(%(<div class="highlight">#{highlighted}</div>))
    end

    # 最後にサニタイズ（必要なタグ/属性だけ許可）
    sanitize(
      frag.to_html,
      tags: %w[p br strong em a code pre h1 h2 h3 h4 h5 h6 ul ol li blockquote table thead tbody tr th td hr img div span],
      attributes: %w[href title src alt class]
    )
  end
end
