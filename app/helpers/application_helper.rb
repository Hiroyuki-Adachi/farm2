module ApplicationHelper
  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(ar)
    render(partial: "error_templete", :locals => { :ar => ar }) if ar.errors.any?
  end

  def data_print(data, kind, url)
    if data.exists?
      content_tag(:span, class: "border border-info text-info h5 hover", style: "cursor: default", "data-url" => url) do
        kind
      end
    else
      kind
    end
  end
end
