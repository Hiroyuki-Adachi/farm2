class Sorimachi::WorkTypesController < ApplicationController
  include PermitManager
  before_action :set_sorimachi_journal, only: [:edit, :update]

  def edit
    @amounts = SorimachiWorkType.where(sorimachi_journal_id: params[:sorimachi_journal_id]).map{|j| [j.work_type_id, j.amount]}.to_h
    @work_types = WorkType.cost.by_term(current_term)
    render layout: false
  end

  def update
    SorimachiWorkType.transaction do
      SorimachiWorkType.refresh(@journal.id, params[:sorimachi])
    end
    @accounts = SorimachiAccount.to_h(@journal.term)
    render partial: 'sorimachi/imports/detail', locals: {detail: @journal}
  end

  private

  def set_sorimachi_journal
    @journal = SorimachiJournal.find(params[:sorimachi_journal_id])
  end
end
