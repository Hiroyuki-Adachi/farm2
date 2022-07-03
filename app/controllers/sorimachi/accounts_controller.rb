class Sorimachi::AccountsController < ApplicationController
  include PermitManager

  def new
    SorimachiAccount.transaction do
      SorimachiAccount.import(current_term)
      SorimachiJournal.update_cost_flag(current_term)
    end
    redirect_to sorimachi_imports_path
  end
end
