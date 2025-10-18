# == Schema Information
#
# Table name: work_categories(作業カテゴリ)
#
#  id                         :bigint           not null, primary key
#  discarded_at(論理削除日時) :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(名称)                 :string(10)       default(""), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class WorkCategory < ApplicationRecord
  include Discard::Model
end
