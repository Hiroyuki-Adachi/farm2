class GapsController < ApplicationController
  include PermitManager

  private

  def menu_name
    return "gaps_#{controller_name}"
  end
end
