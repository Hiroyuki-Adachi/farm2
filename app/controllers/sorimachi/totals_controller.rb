class Sorimachi::TotalsController < ApplicationController
  include PermitManager

  def index
    @accounts = SorimachiAccount.to_h(current_term)
    @totals = SorimachiJournal.total(current_term)
    render layout: false
  end
end
