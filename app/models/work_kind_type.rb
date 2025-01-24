# == Schema Information
#
# Table name: work_kind_types(作業種別分類対応マスタ)
#
#  id           :integer          not null, primary key
#  work_kind_id :integer
#  work_type_id :integer
#
# Indexes
#
#  index_work_kind_types_on_work_kind_id_and_work_type_id  (work_kind_id,work_type_id) UNIQUE
#

class WorkKindType < ApplicationRecord
  belongs_to :work_kind
  belongs_to :work_type
end
