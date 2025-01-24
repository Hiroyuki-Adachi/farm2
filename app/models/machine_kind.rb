# == Schema Information
#
# Table name: machine_kinds(作業種別機械利用可能マスタ)
#
#  id              :integer          not null, primary key
#  machine_type_id :integer          not null
#  work_kind_id    :integer          not null
#
# Indexes
#
#  machine_kinds_2nd_key  (machine_type_id,work_kind_id) UNIQUE
#

class MachineKind < ApplicationRecord
  belongs_to :machine_type
  belongs_to :work_kind
end
