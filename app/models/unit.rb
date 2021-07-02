class Unit < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "unit"

  enum_accessor :code
end
