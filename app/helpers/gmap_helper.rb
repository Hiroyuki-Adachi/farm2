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

  # Generates a hidden field for a land region with associated metadata.
  # 
  # @param land [Object] The land object containing region and metadata.
  # @param color [String, nil] Optional color for the region.
  # @param text_color [String, nil] Optional text color for the region.
  # @param work_type_id [String, nil] Optional work type identifier.
  #
  # The `land.region` is expected to be a string or object representing the region data.
  # The resulting `data` attributes include:
  # - `id`: The ID of the land.
  # - `place`: The place name of the land.
  # - `area`: The area of the land.
  # - `owner`: The name of the land's owner (or an empty string if not present).
  # - `center`: The center coordinates of the land's region.
  # - `color`: The specified color or an empty string if not provided.
  # - `text-color`: The specified text color or an empty string if not provided.
  # - `work-type`: The specified work type ID or an empty string if not provided.
  #
  # @return [String] A hidden field tag with the specified attributes.
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
