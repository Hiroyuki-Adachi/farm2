class Sorimachi::AccountsController < ApplicationController
  include PermitManager
  before_action :set_sorimachi_account, only: [:edit, :update, :destroy]

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
  end

  def update
    @account.attributes = sorimachi_account_params
    if @account.save
      redirect_to sorimachi_accounts_path
    else
      render action: :edit
    end
  end

  def destroy
    @account.destroy unless @account.new_record?
    redirect_to sorimachi_accounts_path
  end

  private

  def set_sorimachi_account
    @account = SorimachiAccount.find_by(term: current_term, code: params[:code])
    @account = SorimachiAccount.new(term: current_term, code: params[:code]) unless @account
  end

  def sorimachi_account_params
    params.require(:sorimachi_account)
      .permit(
        :term,
        :code,
        :name,
        :cost_flag
      )
  end
end
