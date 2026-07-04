class BanksController < ApplicationController
  def lookup
    bank = Bank.find_by(code: params[:code])
    branch = bank && BankBranch.find_by(bank_code: bank.code, code: params[:branch_code])

    render turbo_stream: [
      turbo_stream.update("bank_code_name", bank&.name),
      turbo_stream.update("branch_code_name", branch&.name)
    ]
  end
end
