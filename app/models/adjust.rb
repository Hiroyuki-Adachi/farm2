class Adjust < ActiveYaml::Base
  include ActiveHash::Enum
  
  set_root_path "config/master"
  set_filename "adjust"

  enum_accessor :per
end