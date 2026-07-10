module BanksHelper
  def bank_code_label(bank_code)
    return bank_code if bank_code.blank?

    name = Bank.find_by(code: bank_code)&.name
    name ? "#{bank_code}(#{name})" : bank_code
  end

  def branch_code_label(bank_code, branch_code)
    return branch_code if bank_code.blank? || branch_code.blank?

    name = BankBranch.find_by(bank_code: bank_code, code: branch_code)&.name
    name ? "#{branch_code}(#{name})" : branch_code
  end
end
