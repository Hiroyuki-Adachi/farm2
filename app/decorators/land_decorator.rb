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
    return h.h(format("%.1f", model.area))
  end

  def self.homes
    hs = []
    hs << ["全て", ""]
    Home.landable.includes(:holder).find_each do |h|
      hs << [h.owner_name, h.id]
    end
    return hs
  end
end
