module ApplicationHelper
  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(ar)
    render(partial: "error_templete", :locals => { :ar => ar }) if ar.errors.any?
  end
end
