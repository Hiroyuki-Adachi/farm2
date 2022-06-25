class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def new
  end

  def create
    SorimachiJournal.transaction do
      SorimachiJournal.import(current_term, params[:import_file])
    end
    redirect_to new_sorimachi_import_path
  rescue => e
    @error = e.message
    render action: :new, status: :internal_server_error
  end
end
