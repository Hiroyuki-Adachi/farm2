module ApplicationHelper
  def hbr(text)
    return simple_format(h(text))
  end
  
  def error_print(ar)
    if ar.errors.any?
      render(partial: "error_templete", :locals => {:ar => ar})
    end
  end
end
