class Sorimachi::WorkTypesController < ApplicationController
  include PermitManager

  def edit
    @work_types = WorkType.cost
    @sorimachi_work_types = SorimachiWorkType.where(sorimachi_journal_id: params[:sorimachi_journal_id])
    @journal = SorimachiJournal.find(params[:sorimachi_journal_id])
    render layout: false
  end

  def update
  end
end
