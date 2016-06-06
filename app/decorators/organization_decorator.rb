class OrganizationDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def localed_daily_workers
    Organization.daily_workers.keys.map do |dw|
      [h.t("status.organization.daily_worker.#{dw}"), dw]
    end
  end
end
