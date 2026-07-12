require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  include SessionsHelper

  test "current_term_jp は現在期の年度名を返す" do
    system = System.new(term_name: "第10期")
    helper = Object.new.extend(SessionsHelper)

    helper.stub(:current_system, system) do
      assert_equal "第10期", helper.current_term_jp
    end
  end

  test "next_term_jp は次期の年度名を返す" do
    system = System.new(term_name: "第11期")
    helper = Object.new.extend(SessionsHelper)

    helper.stub(:next_system, system) do
      assert_equal "第11期", helper.next_term_jp
    end
  end
end
