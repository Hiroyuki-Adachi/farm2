# == Schema Information
#
# Table name: machine_kinds
#
#  id              :integer          not null, primary key
#  machine_type_id :integer          not null
#  work_kind_id    :integer          not null
#

class MachineKind < ActiveRecord::Base
  belongs_to :machine_type
  belongs_to :work_kind
end
