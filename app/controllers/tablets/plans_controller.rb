class Tablets::PlansController < TabletsController
  include PermitManager

  before_action :authorize_current_term!
  before_action :save_system

  private

  def save_system
    System.init(current_organization.id, next_term).save!
  end
end
