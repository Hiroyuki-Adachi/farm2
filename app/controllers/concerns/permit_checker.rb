module PermitChecker
  extend ActiveSupport::Concern

  included do
    before_action :permit_checker
  end

  private

  def permit_checker
    to_error_path unless current_user.checkable?
  end
end
