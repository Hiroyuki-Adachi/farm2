# == Schema Information
#
# Table name: land_term_marks(土地年度別記号)
#
#  id             :bigint           not null, primary key
#  mark(記号)     :string(10)       not null
#  term(年度(期)) :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  land_id(土地)  :bigint           not null
#
# Indexes
#
#  index_land_term_marks_on_land_id_and_term  (land_id,term) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (land_id => lands.id)
#
require "test_helper"

class LandTermMarkTest < ActiveSupport::TestCase
  test "同じ年度の同じ土地は重複不可" do
    land_term_mark = LandTermMark.new(
      land: land_term_marks(:land_term_mark1).land,
      term: land_term_marks(:land_term_mark1).term,
      mark: "B"
    )

    assert_not land_term_mark.valid?
    assert_not_empty land_term_mark.errors[:land_id]
  end

  test "年度が異なれば同じ土地でも登録できる" do
    land_term_mark = LandTermMark.new(
      land: land_term_marks(:land_term_mark1).land,
      term: land_term_marks(:land_term_mark1).term + 1,
      mark: "B"
    )

    assert land_term_mark.valid?
  end
end
