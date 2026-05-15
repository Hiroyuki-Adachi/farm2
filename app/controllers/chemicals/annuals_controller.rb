class Chemicals::AnnualsController < ApplicationController
  include PermitManager
  include PermitThisTerm

  def create
    ActiveRecord::Base.transaction do
      ChemicalTerm.annual_update(previous_term, current_term, current_organization)
      ChemicalWorkType.annual_update(previous_term, current_term, current_organization)
    end
    redirect_to chemicals_path
  end
end
