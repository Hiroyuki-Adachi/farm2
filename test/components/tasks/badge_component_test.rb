require "test_helper"
require "view_component/test_case"

class Tasks::BadgeComponentTest < ViewComponent::TestCase
  test "renders text with given css class" do
    render_inline(Tasks::BadgeComponent.new(text: "新規", css_class: "badge bg-info"))

    assert_selector("span.badge.bg-info", text: "新規")
  end

  test "renders extra html options" do
    render_inline(Tasks::BadgeComponent.new(text: "●", css_class: "text-danger", title: "監視中"))

    assert_selector("span.text-danger[title='監視中']", text: "●")
  end

  test "merges css_class with an extra class passed via html_options" do
    render_inline(Tasks::BadgeComponent.new(text: "新規", css_class: "badge bg-info", class: "ms-1"))

    assert_selector("span.badge.bg-info.ms-1", text: "新規")
  end
end
