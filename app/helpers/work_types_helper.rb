module WorkTypesHelper
  def work_type_icon_tag(work_type)
    if work_type.icon.present?
      path = "/farm2/work_types/#{work_type.id}/icon?v=#{ERB::Util.url_encode(work_type.icon_fingerprint)}"
      image_tag(
        path, 
        size: "48x48",
        loading: "lazy",
        decoding: "async",
        alt: work_type.icon_name.presence || "icon"
      )
    else
      image_tag("/images/works/default.png", size: "48x48", loading: "lazy", decoding: "async", alt: "default")
    end
  end
end
