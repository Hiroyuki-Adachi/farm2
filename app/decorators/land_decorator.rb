class LandDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def area
    h.h(format("%.1f", model.area))
  end

  def self.homes(organization = nil)
    hs = []
    hs << ["全て", ""]
    homes = Home.for_land_select.includes(:holder)
    homes = homes.for_organization(organization) if organization.present?

    homes.each do |h|
      hs << [h.owner_name, h.id]
    end
    hs
  end
end
