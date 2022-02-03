class Chemicals::AnnualsController < ApplicationController
  include PermitManager

  def create
    ActiveRecord::Base.transaction do
      ChemicalTerm.annual_update(previous_term, current_term)
    end
    redirect_to chemicals_path
  end
end
