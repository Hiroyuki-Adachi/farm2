class Dilution < ActiveYaml::Base
  include ActiveHash::Enum 

  set_root_path "config/master"
  set_filename "dilution"

  enum_accessor :code
end
