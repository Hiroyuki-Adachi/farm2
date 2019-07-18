class DryingType < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "drying_type"

  enum_accessor :code
end
