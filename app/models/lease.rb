class Lease < ActiveYaml::Base
  include ActiveHash::Enum
  
  set_root_path "config/master"
  set_filename "lease"

  enum_accessor :mode
end