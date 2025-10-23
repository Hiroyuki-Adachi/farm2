# == Schema Information
#
# Table name: work_kind_types(作業種別分類対応マスタ)
#
#  id(作業種別分類対応マスタ)     :integer          not null, primary key
#  work_category_id(作業カテゴリ) :bigint           not null
#  work_kind_id(作業種別)         :integer
#
# Indexes
#
#  index_work_kind_types_on_work_category_id  (work_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_category_id => work_categories.id)
#

class WorkKindType < ApplicationRecord
  belongs_to :work_kind
  belongs_to :category, class_name: "WorkCategory", foreign_key: "work_category_id"
end
