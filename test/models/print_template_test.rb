require "test_helper"

# == Schema Information
#
# Table name: print_templates(定型用紙マスタ)
#
#  id                      :bigint           not null, primary key
#  active(有効)            :boolean          default(TRUE), not null
#  display_order(表示順)   :integer          default(0), not null
#  paper_size(用紙サイズ)  :integer          default("a4"), not null
#  pdf_data(原紙PDF)       :binary           not null
#  sides(印刷面)           :integer          default("one_sided"), not null
#  title(用紙名)           :string(40)       not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  organization_id(組織ID) :bigint           not null
#
# Indexes
#
#  index_print_templates_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class PrintTemplateTest < ActiveSupport::TestCase
  setup do
    @template = print_templates(:print_template_daily)
    @pdf = file_fixture("print_template.pdf").binread
  end

  test "必須項目がないと登録できない" do
    template = PrintTemplate.new(organization_id: 1)
    assert_not template.valid?
    assert template.errors.added?(:title, :blank)
    assert template.errors.added?(:pdf_data, :blank)
  end

  test "PDFでないファイルは登録できない" do
    template = PrintTemplate.new(organization_id: 1, title: "試験", pdf_data: "not a pdf")
    assert_not template.valid?
    assert template.errors.added?(:pdf_data, :not_pdf)
  end

  test "大きすぎるPDFは登録できない" do
    data = PrintTemplate::PDF_SIGNATURE + ("0" * PrintTemplate::MAX_PDF_SIZE)
    template = PrintTemplate.new(organization_id: 1, title: "試験", pdf_data: data)
    assert_not template.valid?
    assert template.errors.added?(:pdf_data, :too_large, count: 5)
  end

  test "PDFを登録できる" do
    template = PrintTemplate.new(organization_id: 1, title: "試験", pdf_data: @pdf, paper_size: :a4,
                                 sides: :two_sided_long_edge)
    assert template.save
    assert_equal @pdf.b, template.reload.pdf_data.b
  end

  test "CUPSに渡す値に変換できる" do
    assert_equal "iso_a5_148x210mm", @template.cups_media
    assert_equal "one-sided", @template.cups_sides

    @template.paper_size = :a4
    @template.sides = :two_sided_short_edge
    assert_equal "iso_a4_210x297mm", @template.cups_media
    assert_equal "two-sided-short-edge", @template.cups_sides
  end

  test "一覧用スコープではPDFを読み込まない" do
    template = PrintTemplate.without_pdf.find(@template.id)
    assert_not template.has_attribute?(:pdf_data)
    assert_equal @template.title, template.title
  end

  test "組織で絞り込める" do
    ids = PrintTemplate.for_organization(organizations(:org)).ids
    assert_includes ids, @template.id
    assert_not_includes ids, print_templates(:print_template_other_org).id
  end

  test "有効な用紙だけを表示順に取得できる" do
    templates = PrintTemplate.for_organization(organizations(:org)).available
    assert_equal [@template.id], templates.ids
  end

  test "未処理の印刷指示がない場合はPDF・用紙設定を変更できる" do
    @template.paper_size = :a4
    @template.sides = :two_sided_long_edge
    @template.pdf_data = "#{@pdf}\n"
    assert @template.save
  end

  PrintJob::PENDING_STATUSES.each do |status|
    test "#{status}の印刷指示がある場合はPDF・用紙設定を変更できない" do
      create_job(status)

      { pdf_data: "#{@pdf}\n", paper_size: "a4", sides: "two_sided_long_edge" }.each do |attr, value|
        template = PrintTemplate.find(@template.id)
        template[attr] = value
        assert_not template.save, "#{attr}を変更できてしまう"
        assert template.errors.added?(:base, :pending_print_jobs)
      end
    end
  end

  test "未処理の印刷指示があっても用紙名・有効・表示順は変更できる" do
    create_job(:waiting)
    assert @template.update(title: "日報用紙(新)", active: false, display_order: 9)
  end

  test "処理済みの印刷指示しかない場合は変更できる" do
    create_job(:failed)
    create_job(:unknown)
    assert @template.update(paper_size: :a4)
  end

  test "印刷指示がある用紙は削除できない" do
    assert_no_difference("PrintTemplate.count") do
      assert_not @template.destroy
    end
    assert_not_empty @template.errors[:base]
  end

  test "印刷指示がない用紙は削除できる" do
    assert_difference("PrintTemplate.count", -1) do
      print_templates(:print_template_inactive).destroy
    end
  end

  private

  def create_job(status)
    PrintJob.create!(organization_id: 1, print_template: @template, requested_by: users(:users1), copies: 1,
                     status: status)
  end
end
