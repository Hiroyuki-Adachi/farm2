module ApplicationHelper
  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(ar)
    render(partial: "error_templete", :locals => { :ar => ar }) if ar.errors.any?
  end

  def data_print(data, kind)
    if data.count == 0
      kind
    else
      content_tag(:span, class: "border border-info text-info h5", style: "cursor: default") do
        kind
      end
    end
  end
end
