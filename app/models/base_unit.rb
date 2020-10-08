class BaseUnit  < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "base_unit"

  enum_accessor :code
end
