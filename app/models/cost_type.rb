# == Schema Information
#
# Table name: cost_types
#
#  id                               :bigint           not null, primary key
#  display_order(表示順)            :integer          default(0), not null
#  name(原価種別名称)               :string(10)       not null
#  phonetic(原価種別名称(ふりがな)) :string(20)       not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
class CostType < ApplicationRecord
end
