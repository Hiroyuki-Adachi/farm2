module ReturnToIndex
  extend ActiveSupport::Concern

  class_methods do
    def keeps_index_return_to(path_method:, only: [:new, :create, :edit, :update, :destroy])
      before_action only: only do
        set_index_return_to(path_method)
      end
    end
  end

  private

  def set_index_return_to(path_method)
    fallback = public_send(path_method)
    return_to = safe_return_to_path(params[:return_to], fallback: fallback, allowed_paths: [fallback])
    @return_to = normalize_destroy_return_to(return_to)
  end

  def normalize_destroy_return_to(return_to)
    return return_to unless action_name == "destroy"

    uri = URI.parse(return_to)
    return return_to unless uri.query.present?

    query_params = Rack::Utils.parse_nested_query(uri.query)
    page = query_params["page"].to_i
    return return_to unless page > 1

    if page == 2
      query_params.delete("page")
    else
      query_params["page"] = (page - 1).to_s
    end

    uri.query = query_params.present? ? query_params.to_query : nil
    uri.to_s
  rescue URI::InvalidURIError
    return_to
  end
end
