class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
    @journals = SorimachiJournal.usual(current_term).page(params[:page])
    @details = SorimachiJournal.details(@journals).to_a
    @accounts = SorimachiAccount.where(term: current_term).map {|a| [a.code, a.name]}.to_h
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
