module PermitManager
  extend ActiveSupport::Concern

  included do
    before_action :permit_manager
  end

  private

  def permit_manager
    to_error_path unless current_user.manageable?
  end
end
