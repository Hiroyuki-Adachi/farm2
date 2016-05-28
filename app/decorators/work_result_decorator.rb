class WorkResultDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def worker_name(organization)
    if organization.print_home?
      return model.worker.name + "(" + model.worker.home.name + ")"
    elsif organization.print_section?
      return model.worker.name + "(" + model.worker.home.section.name + ")"
    end
    return model.worker.name
  end

end
