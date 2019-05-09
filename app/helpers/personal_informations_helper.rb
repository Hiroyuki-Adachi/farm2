module PersonalInformationsHelper
  def image_name(work_type)
    "/images/works/" + case work_type.id
    when 8,39,41 then
        "wcs.jpg"
    when 27 then
        "broccoli.png"
    when 32 then
        "soy.jpg"
    when 33 then
        "redbean.jpg"
    when 11 then
        "desk.jpg"
    when 12 then
        "farm1.png"
    when 13 then
        "spanner.png"
    when 38 then
        "farm2.png"
    when 42 then
        "bank.jpg"
    when 43 then
        "PC.png"
    when 3 then
        "grass.png"
    when 44 then
        "hands.jpg"
    when 9 then
        "straw.jpg"
    else
        "rice.png"
    end
  end
end
