class GapsController < ApplicationController
  include PermitManager

  private

  def menu_name
    "gaps_#{controller_name}"
  end
end
