module WorkTypesHelper
  def work_type_icon_tag(work_type)
    if work_type.icon.present?
      image_tag(
        icon_work_type_path(work_type, v: work_type.icon_fingerprint, script_name: ""),
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
