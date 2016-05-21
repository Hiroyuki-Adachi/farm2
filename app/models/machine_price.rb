class MachinePrice < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :lease
  belongs_to :machine_type
  belongs_to :machine
  belongs_to :work_kind
  
  scope :list, -> {order(:validity_at)}
  scope :show, -> {includes(:work_kind).order("work_kinds.display_order NULLS FIRST, lease_flag")}
end