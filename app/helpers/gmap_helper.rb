module GmapHelper
  def current_location
    return "#{current_organization.location.x},#{current_organization.location.y}"
  end

  def land_location(land)
    return "#{land.region_center[0]},#{land.region_center[1]}" if land.region.present?
    return "#{current_organization.location.x},#{current_organization.location.y}" 
  end

  def home_location(home)
    return "(#{home.location ? home.location.x : current_organization.location.x},#{home.location ? home.location.y : current_organization.location.y})"
  end

  def land_region_hidden_field(land, color: nil, text_color: nil, work_type_id: nil)
    data = {
      id: land.id,
      place: land.place,
      area: land.area,
      owner: land&.owner&.name || '',
      center: land.region_center,
      color: color || '',
      "text-color" => text_color || '',
      "work-type" => work_type_id || '',
    }
  
    hidden_field_tag :regions, land.region, id: "land_#{land.id}", data: data
  end
end
