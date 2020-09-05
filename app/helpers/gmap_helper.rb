module GmapHelper
  def current_location
    return "#{current_organization.location.x},#{current_organization.location.y}"
  end

  def land_location(land)
    return "#{current_organization.location.x},#{current_organization.location.y}"
  end
end
