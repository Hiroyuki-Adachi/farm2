class Sorimachi::ImportsController < ApplicationController
  include PermitManager
  before_action :set_sorimachi_journal, only: [:update, :destroy]
  before_action :set_sorimachi_accounts, only: [:index, :update, :destroy]

  def index
    @journals = SorimachiJournal.usual(current_term).page(params[:page])
    @details = SorimachiJournal.details(@journals).to_a
  end

  def create
    SorimachiJournal.transaction do
      SorimachiJournal.import(current_term, params[:import_file])
      SorimachiJournal.update_cost_flag(current_term)
      SorimachiJournal.refresh(current_term)
    end
    redirect_to sorimachi_imports_path
  rescue => e
    @error = e.message
    render action: :index, status: :internal_server_error
  end

  def update
    @journal.update_flags
    render partial: 'detail', locals: {detail: @journal}
  end

  def destroy
    @journal.clear_flags
    render partial: 'detail', locals: {detail: @journal}
  end

  private

  def set_sorimachi_journal
    @journal = SorimachiJournal.find(params[:id])
  end

  def set_sorimachi_accounts
    @accounts = SorimachiAccount.to_h(current_term)
  end
end
