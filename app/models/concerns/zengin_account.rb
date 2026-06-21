module ZenginAccount
  extend ActiveSupport::Concern

  def bank_account_incomplete?
    bank_code.blank? || bank_code == "0000" ||
      branch_code.blank? || branch_code == "000" ||
      account_type_id_unset? ||
      account_number.blank? || account_number == "0000000"
  end
end
