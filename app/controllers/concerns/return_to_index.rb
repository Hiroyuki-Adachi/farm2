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
    fallback = validated_index_return_to_fallback(public_send(path_method))
    @return_to = safe_return_to_path(params[:return_to], fallback: fallback, allowed_paths: [fallback])
  end

  def validated_index_return_to_fallback(fallback)
    fallback = fallback.to_s
    return "/" if fallback.blank?
    return "/" unless local_return_to_path?(fallback)

    fallback
  rescue URI::InvalidURIError
    "/"
  end

  def local_return_to_path?(path)
    uri = URI.parse(path)

    uri.scheme.nil? && uri.host.nil? && path.start_with?("/") && !path.start_with?("//")
  end
end
