# == Schema Information
#
# Table name: pesticide_masters(統合農薬マスタ)
#
#  id                                    :bigint           not null, primary key
#  formulation_name(剤型名)              :string(50)       default(""), not null
#  mixture_count(混合数)                 :integer          default(0), not null
#  name(農薬の名称)                      :string(255)      default(""), not null
#  pesticide_kind(農薬の種類)            :string(255)      default(""), not null
#  registered_on(登録年月日)             :date
#  registrant_name(登録を有する者の名称) :string(255)      default(""), not null
#  registration_number(登録番号)         :integer          not null
#  usage(用途)                           :string(50)       default(""), not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_pesticide_masters_on_registration_number  (registration_number) UNIQUE
#
require "test_helper"
require "tempfile"

class PesticideMasterTest < ActiveSupport::TestCase
  test "chemicals から統合農薬マスタを参照できる" do
    chemical = chemicals(:chemicals1)

    assert_equal pesticide_masters(:pesticide_masters1), chemical.pesticide_master
  end

  test "zip から基本部を登録番号単位で取り込める" do
    zip_path = build_zip(<<~CSV)
      登録番号,農薬の種類,農薬の名称,登録を有する者の名称,有効成分,総使用回数における有効成分,濃度,混合数,用途,剤型名,登録年月日
      2122,液状展着剤,ネオエステリン,クミアイ化学工業株式会社,A,,20.0%,1,その他,その他,1955/2/23
      2122,液状展着剤,ネオエステリン,クミアイ化学工業株式会社,B,,10.0%,1,その他,その他,1955/2/23
      2280,マラソン乳剤,日農マラソン乳剤,日本農薬株式会社,マラソン,マラソン,50.0%,1,殺虫剤,乳剤,1955/5/23
    CSV

    assert_difference("PesticideMaster.count", 1) do
      stats = PesticideMaster.import_file!(zip_path)
      assert_equal 3, stats[:total_rows]
      assert_equal 2, stats[:imported]
      assert_equal 1, stats[:created]
      assert_equal 1, stats[:updated]
    end

    record = PesticideMaster.find_by!(registration_number: 2122)
    assert_equal "ネオエステリン", record.name
    assert_equal "液状展着剤", record.pesticide_kind
    assert_equal "クミアイ化学工業株式会社", record.registrant_name
    assert_equal "その他", record.usage
    assert_equal "その他", record.formulation_name
    assert_equal Date.new(1955, 2, 23), record.registered_on
  ensure
    File.unlink(zip_path) if zip_path && File.exist?(zip_path)
  end

  private

  def build_zip(csv_text)
    file = Tempfile.new(["pesticide_masters", ".zip"])
    file.close

    Zip::OutputStream.open(file.path) do |zip|
      zip.put_next_entry("R0803180.csv")
      zip.write(csv_text.encode("CP932"))
    end

    file.path
  end
end
