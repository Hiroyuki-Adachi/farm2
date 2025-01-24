# == Schema Information
#
# Table name: machine_kinds(作業種別機械利用可能マスタ)
#
#  id(作業種別機械利用可能マスタ) :integer          not null, primary key
#  machine_type_id(機械種別)      :integer          not null
#  work_kind_id(作業種別)         :integer          not null
#
# Indexes
#
#  machine_kinds_2nd_key  (machine_type_id,work_kind_id) UNIQUE
#

class MachineKind < ApplicationRecord
  belongs_to :machine_type
  belongs_to :work_kind
end
