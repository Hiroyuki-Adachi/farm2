class Position < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "position"

  enum_accessor :code
end
