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
    @return_to = safe_return_to_path(params[:return_to], fallback: fallback, allowed_paths: [fallback])
  end
end
