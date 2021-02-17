class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
  end

  def create
    SorimachiJournal.import(current_term, params[:import_file])
    redirect_to new_sorimachi_import_path
  end
end
