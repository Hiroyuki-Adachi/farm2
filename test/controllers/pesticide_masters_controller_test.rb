require "test_helper"

class PesticideMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @pesticide_master = pesticide_masters(:pesticide_masters1)
  end

  test "統合農薬マスタ一覧" do
    get pesticide_masters_path
    assert_response :success
    assert_match @pesticide_master.name, response.body
  end

  test "統合農薬マスタ照会" do
    get pesticide_master_path(@pesticide_master)
    assert_response :success
    assert_match @pesticide_master.registration_number.to_s, response.body
  end

  test "統合農薬マスタインポート" do
    zip_path = build_zip(<<~CSV)
      登録番号,農薬の種類,農薬の名称,登録を有する者の名称,有効成分,総使用回数における有効成分,濃度,混合数,用途,剤型名,登録年月日
      999999,試験剤,試験農薬,試験会社,A,,20.0%,1,その他,液剤,2026/3/29
    CSV

    assert_difference("PesticideMaster.count", 1) do
      post pesticide_masters_path, params: {import_file: fixture_file_upload(zip_path, "application/zip")}
    end

    assert_redirected_to pesticide_masters_path
    assert_equal "試験農薬", PesticideMaster.find_by!(registration_number: 999999).name
  ensure
    File.unlink(zip_path) if zip_path && File.exist?(zip_path)
  end

  private

  def build_zip(csv_text)
    file = Tempfile.new(["pesticide_masters_controller", ".zip"])
    file.close

    Zip::OutputStream.open(file.path) do |zip|
      zip.put_next_entry("R0803180.csv")
      zip.write(csv_text.encode("CP932"))
    end

    file.path
  end
end
