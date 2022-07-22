class TotalCostType < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "total_cost_type"

  enum_accessor :code

  scope :accountable, -> {where.not(account: nil).order(:id)}
end
