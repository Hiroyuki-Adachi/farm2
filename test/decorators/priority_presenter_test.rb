require "test_helper"

class PriorityPresenterTest < ActiveSupport::TestCase
  class DummyDecorator
    include PriorityPresenter

    def h
      ActionController::Base.helpers
    end
  end

  test "priority_name はタスクの優先度に対応する翻訳を返す" do
    decorator = DummyDecorator.new

    assert_equal I18n.t("activerecord.enums.task.priorities.low"), decorator.priority_name(:low)
    assert_equal I18n.t("activerecord.enums.task.priorities.urgent"), decorator.priority_name(:urgent)
  end

  test "priority_color は優先度に対応するバッジ色を返す" do
    decorator = DummyDecorator.new

    assert_equal I18n.t("activerecord.enums.task.priority_colors.low"), decorator.priority_color(:low)
    assert_equal I18n.t("activerecord.enums.task.priority_colors.urgent"), decorator.priority_color(:urgent)
  end

  test "priority_badge は優先度に応じたバッジを生成する" do
    decorator = DummyDecorator.new

    assert decorator.priority_badge(:low).include?("badge text-bg-")
    assert decorator.priority_badge(:low).include?(decorator.priority_name(:low))
    assert decorator.priority_badge(:low).include?(decorator.priority_color(:low))
  end
end
