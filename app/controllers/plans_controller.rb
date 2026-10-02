class PlansController < ApplicationController
  include PermitManager

  before_action :authorize_current_term!
  before_action :save_system

  protected

  def save_system
    System.ensure_for_planning!(current_organization, next_term)
  end
end
