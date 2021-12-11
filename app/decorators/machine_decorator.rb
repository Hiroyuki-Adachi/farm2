class MachineDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def price_tag
    if model.owner.company_flag
      return h.raw("&nbsp;")
    else
      return h.link_to('料金設定', h.show_machine_machine_price_headers_path(machine_id: model), {class: "btn btn-success btn-sm"}) 
    end
  end

  def operators(work)
    operators = []
    work.work_results.each do |result|
      operators << WorkerDecorator.decorate(result.worker).short_name if model.work_results.include?(result)
    end

    return operators.join(',')
  end

  def remarks(work)
    return MachineRemark.find_by(machine_id: model.id, work_id: work)
  end
end
