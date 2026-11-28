require "application_system_test_case"

class PrintTemplatesTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "定型用紙を登録できる" do
    login

    visit print_templates_path
    assert_selector "h1", text: "定型用紙マスタ一覧"
    assert_selector "tbody", text: "日報用紙"
    assert_no_selector "tbody", text: "別組織の日報用紙"

    click_link "新規登録"
    assert_selector "h1", text: "定型用紙マスタ新規登録"
    fill_in "print_template_title", with: "田植え農薬記入表(新)"
    fill_in "print_template_display_order", with: "3"
    attach_pdf "print_template_pdf_file", file_fixture("print_template.pdf")
    select "A4", from: "print_template_paper_size"
    select "両面(長辺とじ)", from: "print_template_sides"
    click_button "登録"

    assert_selector "h1", text: "定型用紙マスタ一覧"
    assert_selector "tbody tr", text: /田植え農薬記入表\(新\).*A4.*両面\(長辺とじ\)/
    template = PrintTemplate.find_by!(title: "田植え農薬記入表(新)")
    assert_equal file_fixture("print_template.pdf").binread.b, template.pdf_data.b
  end

  test "定型用紙を無効にできる" do
    login

    visit print_templates_path
    within "tbody tr", text: "日報用紙" do
      click_link "修正"
    end

    assert_selector "h1", text: "定型用紙マスタ修正"
    assert_link "登録済みのPDFを表示"
    uncheck "print_template_active"
    click_button "登録"

    assert_selector "h1", text: "定型用紙マスタ一覧"
    assert_selector "tbody tr.table-warning", text: "日報用紙"
    assert_not print_templates(:print_template_daily).reload.active?
  end

  test "未処理の印刷指示がある用紙は警告を表示し用紙設定を変更できない" do
    template = print_templates(:print_template_daily)
    PrintJob.create!(organization_id: 1, print_template: template, requested_by: @user, copies: 1)
    login

    visit edit_print_template_path(template)
    assert_selector ".alert-warning", text: "未処理の印刷指示があるため"
    select "A4", from: "print_template_paper_size"
    click_button "登録"

    assert_selector "h1", text: "定型用紙マスタ修正"
    assert_text "未処理の印刷指示があるため、原紙PDF・用紙サイズ・印刷面は変更できません。"
    assert template.reload.paper_size_a5?
  end

  private

  # システムテストのChromeは別コンテナで動くため、attach_fileではローカルのファイルを読めない。
  # ファイルの内容をJavaScriptで input[type=file] に設定する。
  def attach_pdf(id, path)
    execute_script(<<~JS, id, Base64.strict_encode64(File.binread(path)), File.basename(path))
      const [id, data, name] = arguments;
      const bytes = Uint8Array.from(atob(data), (c) => c.charCodeAt(0));
      const transfer = new DataTransfer();
      transfer.items.add(new File([bytes], name, { type: "application/pdf" }));
      document.getElementById(id).files = transfer.files;
    JS
  end

  def login
    visit root_path
    fill_in "login_name", with: @user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", text: "作業日報管理"
  end
end
