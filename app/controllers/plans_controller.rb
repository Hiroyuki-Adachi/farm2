class PlansController < ApplicationController
  include PermitManager
  before_action :permit_this_term
  before_action :save_system

  protected

  def save_system
    System.init(current_organization.id, next_term).save!
  end
end
