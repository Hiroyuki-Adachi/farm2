class BanksController < ApplicationController
  def lookup
    bank = Bank.find_by(code: params[:code])
    branch = bank.bank_branches.find_by(code: params[:branch_code]) if bank && params[:branch_code].present?

    render turbo_stream: [
      turbo_stream.update("bank_code_name", bank&.name),
      turbo_stream.update("branch_code_name", branch&.name)
    ]
  end
end
