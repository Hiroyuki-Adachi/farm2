# == Schema Information
#
# Table name: pesticide_masters(統合農薬マスタ)
#
#  id                                                       :bigint           not null, primary key
#  formulation_name(剤型名)                                 :string(50)       default(""), not null
#  formulation_name_normalized(剤型名(正規化))              :string(50)       default(""), not null
#  mixture_count(混合数)                                    :integer          default(0), not null
#  name(農薬の名称)                                         :string(255)      default(""), not null
#  name_normalized(農薬の名称(正規化))                      :string(255)      default(""), not null
#  pesticide_kind(農薬の種類)                               :string(255)      default(""), not null
#  pesticide_kind_normalized(農薬の種類(正規化))            :string(255)      default(""), not null
#  registered_on(登録年月日)                                :date
#  registrant_name(登録を有する者の名称)                    :string(255)      default(""), not null
#  registrant_name_normalized(登録を有する者の名称(正規化)) :string(255)      default(""), not null
#  registration_number(登録番号)                            :integer          not null
#  usage(用途)                                              :string(50)       default(""), not null
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
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

  test "正規化列に半角カナの全角変換結果を保持する" do
    record = pesticide_masters(:pesticide_masters1)

    assert_equal "日農マラソン乳剤", record.name_normalized
    assert_equal "マラソン乳剤", record.pesticide_kind_normalized
    assert_equal "日本農薬株式会社", record.registrant_name_normalized
    assert_equal "乳剤", record.formulation_name_normalized
  end

  test "zip から基本部を登録番号単位で取り込める" do
    zip_path = build_zip(<<~CSV)
      登録番号,農薬の種類,農薬の名称,登録を有する者の名称,有効成分,総使用回数における有効成分,濃度,混合数,用途,剤型名,登録年月日
      2122,液状展着剤,ﾈｵｴｽﾃﾘﾝ,ｸﾐｱｲ化学工業株式会社,A,,20.0%,1,その他,ｴｱｿﾞﾙ,1955/2/23
      2122,液状展着剤,ﾈｵｴｽﾃﾘﾝ,ｸﾐｱｲ化学工業株式会社,B,,10.0%,1,その他,ｴｱｿﾞﾙ,1955/2/23
      2280,ﾏﾗｿﾝ乳剤,日農ﾏﾗｿﾝ乳剤,日本農薬株式会社,ﾏﾗｿﾝ,ﾏﾗｿﾝ,50.0%,1,殺虫剤,乳剤,1955/5/23
    CSV

    assert_difference("PesticideMaster.count", 1) do
      stats = PesticideMaster.import_file!(zip_path)
      assert_equal 3, stats[:total_rows]
      assert_equal 2, stats[:imported]
      assert_equal 1, stats[:created]
      assert_equal 0, stats[:updated]
    end

    record = PesticideMaster.find_by!(registration_number: 2122)
    assert_equal "ﾈｵｴｽﾃﾘﾝ", record.name
    assert_equal "ネオエステリン", record.name_normalized
    assert_equal "液状展着剤", record.pesticide_kind
    assert_equal "クミアイ化学工業株式会社", record.registrant_name_normalized
    assert_equal "ｴｱｿﾞﾙ", record.formulation_name
    assert_equal "エアゾル", record.formulation_name_normalized
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
