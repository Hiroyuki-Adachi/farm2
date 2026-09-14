require "application_system_test_case"

class SorimachiImportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @journal = sorimachi_journals(:journal2)

    @work_type_a = create_work_type_for_term("配賦A")
    @work_type_b = create_work_type_for_term("配賦B")
    SorimachiWorkType.create!(sorimachi_journal_id: @journal.id, work_type_id: @work_type_a.id, amount: 6598)
    SorimachiWorkType.create!(sorimachi_journal_id: @journal.id, work_type_id: @work_type_b.id, amount: 6598)
  end

  test "配賦チェックボックスをダブルクリックするとその項目だけが選択される" do
    login_as(@user)
    visit sorimachi_imports_path(total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id)

    checkbox_a = find(checkbox_selector(@work_type_a))
    checkbox_b = find(checkbox_selector(@work_type_b))
    assert checkbox_a.checked?
    assert checkbox_b.checked?

    checkbox_b.double_click

    assert_no_selector "#{checkbox_selector(@work_type_a)}:checked"
    assert_selector "#{checkbox_selector(@work_type_b)}:checked"
  end

  private

  def checkbox_selector(work_type)
    "input.allocation-checkbox[data-journal-id='#{@journal.id}'][data-work-type-id='#{work_type.id}']"
  end

  def create_work_type_for_term(name)
    work_type = WorkType.create!(name: name, genre: work_genres(:genre_change), land_flag: true, work_flag: true)
    work_type.term = @journal.term
    work_type.term_flag = true
    work_type.save!
    work_type
  end

  def login_as(user)
    visit root_path
    fill_in "login_name", with: user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", exact_text: "作業日報管理"
  end
end
