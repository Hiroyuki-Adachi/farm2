class Sorimachi::ImportsController < ApplicationController
  include PermitManager
  before_action :set_sorimachi_journal, only: [:destroy]

  def index
    @journals = SorimachiJournal.usual(current_term).page(params[:page])
    @details = SorimachiJournal.details(@journals).to_a
    @accounts = SorimachiAccount.to_h(current_term)
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

  def destroy
    @journal.clear_flags
    @accounts = SorimachiAccount.to_h(current_term)
    render partial: 'detail',
      locals: {
        detail: @journal,
        has_details: @journal.detail > 1 ? false : (@journal.details.count - 1).positive?
      }
  end

  private

  def set_sorimachi_journal
    @journal = SorimachiJournal.find(params[:id])
  end
end
