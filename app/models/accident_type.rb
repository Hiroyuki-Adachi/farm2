class AccidentType < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "accident_type"

  enum_accessor :code
end
