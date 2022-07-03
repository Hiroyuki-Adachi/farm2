class Sorimachi::AccountsController < ApplicationController
  include PermitManager

  def new
    SorimachiAccount.import(current_term)
    redirect_to sorimachi_imports_path
  end
end
