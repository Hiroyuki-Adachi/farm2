# == Schema Information
#
# Table name: sections # 班／町内マスタ
#
#  id            :integer          not null, primary key
#  name          :string(40)       not null                # 班名称
#  display_order :integer          default(1), not null    # 表示順
#  work_flag     :boolean          default(TRUE), not null # 作業班フラグ
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

class Section < ApplicationRecord
  acts_as_paranoid

  has_many :homes, -> {order("homes.display_order, homes.id")}

  scope :usual, ->{where(work_flag: true).order(display_order: :asc)}
end
