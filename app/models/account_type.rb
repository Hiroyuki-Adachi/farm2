class AccountType < ActiveYaml::Base
  include ActiveHash::Enum
  
  set_root_path "config/master"
  set_filename "account_type"

  enum_accessor :code
end
