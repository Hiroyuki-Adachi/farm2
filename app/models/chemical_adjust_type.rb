class ChemicalAdjustType < ActiveYaml::Base
  include ActiveHash::Enum
  
  set_root_path "config/master"
  set_filename "chemical_adjust_type"
  
  enum_accessor :code
end
