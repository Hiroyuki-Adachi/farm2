require "test_helper"

class PrintTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @template = print_templates(:print_template_daily)
    @pdf = fixture_file_upload("print_template.pdf", "application/pdf")
  end

  test "定型用紙マスタ一覧" do
    get print_templates_path
    assert_response :success
    assert_select "td", text: @template.title
    assert_select "td", text: print_templates(:print_template_other_org).title, count: 0
  end

  test "定型用紙マスタ新規作成(表示)" do
    get new_print_template_path
    assert_response :success
  end

  test "定型用紙マスタ新規作成(実行)" do
    assert_difference("PrintTemplate.count") do
      post print_templates_path,
           params: { print_template: { title: "田植え用", paper_size: "a4", sides: "two_sided_long_edge", active: "1",
                                       display_order: 5, pdf_file: @pdf } }
    end
    assert_redirected_to print_templates_path

    template = PrintTemplate.last
    assert_equal "田植え用", template.title
    assert template.paper_size_a4?
    assert template.sides_two_sided_long_edge?
    assert_equal 5, template.display_order
    assert_equal file_fixture("print_template.pdf").binread.b, template.pdf_data.b
    assert_equal users(:users1).organization_id, template.organization_id
  end

  test "PDFなしでは新規作成できない" do
    assert_no_difference("PrintTemplate.count") do
      post print_templates_path, params: { print_template: { title: "田植え用", paper_size: "a4", sides: "one_sided" } }
    end
    assert_response :unprocessable_content
  end

  test "PDF以外のファイルでは新規作成できない" do
    assert_no_difference("PrintTemplate.count") do
      post print_templates_path,
           params: { print_template: { title: "画像", pdf_file: fixture_file_upload("wcs.jpg", "image/jpeg") } }
    end
    assert_response :unprocessable_content
  end

  test "定型用紙マスタ変更(表示)" do
    get edit_print_template_path(@template)
    assert_response :success
  end

  test "PDFを指定しなければPDFは変わらない" do
    before = @template.pdf_data
    patch print_template_path(@template), params: { print_template: { title: "日報用紙(改)", paper_size: "a4" } }
    assert_redirected_to print_templates_path

    @template.reload
    assert_equal "日報用紙(改)", @template.title
    assert @template.paper_size_a4?
    assert_equal before.b, @template.pdf_data.b
  end

  test "PDFを差し替えられる" do
    new_pdf = Rack::Test::UploadedFile.new(StringIO.new("%PDF-1.4\nnew"), "application/pdf",
                                           original_filename: "new.pdf")
    patch print_template_path(@template), params: { print_template: { title: @template.title, pdf_file: new_pdf } }
    assert_redirected_to print_templates_path
    assert_equal "%PDF-1.4\nnew", @template.reload.pdf_data
  end

  test "未処理の印刷指示がある場合は用紙設定を変更できない" do
    PrintJob.create!(organization_id: 1, print_template: @template, requested_by: users(:users1), copies: 1)
    patch print_template_path(@template), params: { print_template: { paper_size: "a4" } }
    assert_response :unprocessable_content
    assert @template.reload.paper_size_a5?
  end

  test "PDFを表示できる" do
    get pdf_print_template_path(@template)
    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert_equal @template.pdf_data.b, response.body.b
  end

  test "印刷指示のない定型用紙は削除できる" do
    template = print_templates(:print_template_inactive)
    assert_difference("PrintTemplate.count", -1) do
      delete print_template_path(template)
    end
    assert_redirected_to print_templates_path
  end

  test "印刷指示のある定型用紙は削除できない" do
    assert_no_difference("PrintTemplate.count") do
      delete print_template_path(@template)
    end
    assert_redirected_to print_templates_path
    assert_not_nil flash[:alert]
  end

  test "他組織の定型用紙は操作できない" do
    other = print_templates(:print_template_other_org)
    get edit_print_template_path(other)
    assert_response :not_found
    get pdf_print_template_path(other)
    assert_response :not_found
    patch print_template_path(other), params: { print_template: { title: "x" } }
    assert_response :not_found
    delete print_template_path(other)
    assert_response :not_found
  end

  test "管理者以外は利用できない" do
    login_as(users(:user_manager))
    get print_templates_path
    assert_response :service_unavailable
    get pdf_print_template_path(@template)
    assert_response :service_unavailable
  end
end
