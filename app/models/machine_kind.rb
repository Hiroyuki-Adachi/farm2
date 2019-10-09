# == Schema Information
#
# Table name: machine_kinds # 作業種別機械利用可能マスタ
#
#  id              :integer          not null, primary key
#  machine_type_id :integer          not null              # 機械種別
#  work_kind_id    :integer          not null              # 作業種別
#

class MachineKind < ApplicationRecord
  belongs_to :machine_type
  belongs_to :work_kind
end
