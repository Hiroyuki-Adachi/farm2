class Sorimachi::AccountsController < ApplicationController
  include PermitManager

  def index
  end

  def new
    SorimachiAccount.transaction do
      SorimachiJournal.update_cost_flag(current_term)
      SorimachiJournal.refresh(current_term)
    end
    redirect_to sorimachi_imports_path
  end

  def create
    SorimachiAccount.import(current_term)
  end
end
