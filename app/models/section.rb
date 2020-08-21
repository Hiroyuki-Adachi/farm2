# == Schema Information
#
# Table name: sections # 班／町内マスタ
#
#  id(班／町内マスタ)      :integer          not null, primary key
#  deleted_at              :datetime
#  display_order(表示順)   :integer          default(1), not null
#  name(班名称)            :string(40)       not null
#  work_flag(作業班フラグ) :boolean          default(TRUE), not null
#  created_at              :datetime
#  updated_at              :datetime
#
# Indexes
#
#  index_sections_on_deleted_at  (deleted_at)
#
class Section < ApplicationRecord
  acts_as_paranoid

  has_many :homes, -> {order("homes.display_order, homes.id")}

  scope :usual, ->{where(work_flag: true).order(display_order: :asc)}
end
