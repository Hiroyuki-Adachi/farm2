class ExpenseType < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "expense_type"

  enum_accessor :code
end
