module PermitUser
  extend ActiveSupport::Concern

  included do
    before_action :permit_user
  end

  private

  def permit_user
    to_error_path unless current_user.userable?
  end
end
