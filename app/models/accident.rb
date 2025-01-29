# == Schema Information
#
# Table name: accidents(ヒヤリハット)
#
#  id                                :bigint           not null, primary key
#  accident_type(ヒヤリハット種別ID) :integer          default(NULL), not null
#  content(内容)                     :text             default(""), not null
#  informant_name(情報提供者)        :string(40)       default(""), not null
#  investigated_on(調査日)           :date             not null
#  location(場所)                    :point
#  location_name(場所名称)           :string(40)       default(""), not null
#  problem(問題点の考察)             :text             default(""), not null
#  result(改善の結果)                :text             default(""), not null
#  solving(問題解決の考察)           :text             default(""), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  audience_id(対象者ID)             :integer          default(0), not null
#  investigator_id(調査責任者ID)     :integer          default(0), not null
#  work_id(対象日報)                 :integer          not null
#
class Accident < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  enum :accident_type, {rule: 1, hiyari: 2, other: 9}

  belongs_to :work
  belongs_to :investigator, class_name: "Worker"
  belongs_to :audience, class_name: "Worker"

  scope :usual, ->(term) {
    joins(:work).where(works: { term: term }).order("works.worked_at, works.start_at, accidents.id")
  }

  def accident_type_name
    human_attribute_enum(:accident_type)
  end
end
