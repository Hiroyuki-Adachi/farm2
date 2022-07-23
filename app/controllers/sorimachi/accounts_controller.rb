class Sorimachi::AccountsController < ApplicationController
  include PermitManager

  def index
    @journals = SorimachiJournal.accounts(current_term)
    @accounts = SorimachiAccount.to_h(current_term)
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
    redirect_to sorimachi_accounts_path
  end

  def edit
    @account = SorimachiAccount.find_by(term: current_term, code: params[:code])
    @account = SorimachiAccount.new(term: current_term, code: params[:code]) unless @account
  end
end
