class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
    @journals = SorimachiJournal.usual(current_term).page(params[:page])
  end

  def create
    SorimachiJournal.transaction do
      SorimachiJournal.import(current_term, params[:import_file])
    end
    redirect_to sorimachi_imports_path
  rescue => e
    @error = e.message
    render action: :index, status: :internal_server_error
  end
end
