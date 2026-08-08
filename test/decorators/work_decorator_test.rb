require "test_helper"

class WorkDecoratorTest < ActiveSupport::TestCase
  test "組織の年度名と年度を年度順で返す" do
    systems(:s2014).update!(term_name: "第14期")
    systems(:s2015).update!(term_name: "第15期")
    systems(:s2015_org2).update!(term_name: "別組織期")

    terms = WorkDecorator.terms(organizations(:org))

    assert_equal ["第14期", 2014], terms.first
    assert_includes terms, ["第15期", 2015]
    assert_not_includes terms, ["別組織期", 2015]
  end
end
