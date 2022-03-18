class ChemicalTypeDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def delete_link
    if model.chemicals.count.zero?
      return h.link_to('削除', model, {data: {confirm: "本当に削除してもよろしいですか?", turbo_method: :delete}, class: "btn btn-danger btn-sm"})
    else
      return h.raw("&nbsp;")
    end
  end
end
