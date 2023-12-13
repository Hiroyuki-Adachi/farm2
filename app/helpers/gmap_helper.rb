module GmapHelper
  def current_location
    return "#{current_organization.location.x},#{current_organization.location.y}"
  end

  def land_location(land)
    return "#{land.region_center[0]},#{land.region_center[1]}" if land.region.present?
    return "#{current_organization.location.x},#{current_organization.location.y}" 
  end

  def zgis_polygon(land)
    return "" if land.region.empty?
    polygons = land.region_values.map { |region| "#{region[1]} #{region[0]}" }
    return "'Polygon((#{polygons.join(",")}))"
  end

  def home_location(home)
    return "(#{home.location ? home.location.x : current_organization.location.x},#{home.location ? home.location.y : current_organization.location.y})"
  end
end
