class Permission < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "permission"

  enum_accessor :code
end
