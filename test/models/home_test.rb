# == Schema Information
#
# Table name: homes(世帯マスタ)
#
#  id(世帯マスタ)                      :integer          not null, primary key
#  address1(住所1)                     :string(50)
#  address2(住所2)                     :string(50)
#  company_flag(営農組合フラグ)        :boolean          default(FALSE), not null
#  deleted_at                          :datetime
#  display_order(表示順)               :integer
#  drying_order(出力順(乾燥調整用))    :integer
#  fax(FAX番号)                        :string(15)
#  finance_order(出力順(会計用))       :integer
#  land_flag(土地フラグ)               :boolean          default(TRUE), not null
#  location(位置)                      :point
#  member_flag(組合員フラグ)           :boolean          default(TRUE), not null
#  name(世帯名)                        :string(10)
#  owned_rice_order(出力順(保有米))    :integer
#  owner_flag(所有者フラグ)            :boolean          default(FALSE), not null
#  phonetic(世帯名(よみ))              :string(15)
#  seedling_order(出力順(育苗用))      :integer
#  telephone(電話番号)                 :string(15)
#  worker_payment_flag(個人支払フラグ) :boolean          default(FALSE), not null
#  zip_code(郵便番号)                  :string(7)
#  created_at                          :datetime
#  updated_at                          :datetime
#  organization_id(組織)               :bigint           default(1), not null
#  section_id(班／町内)                :integer
#  worker_id(世帯主(代表者))           :integer
#
# Indexes
#
#  index_homes_on_deleted_at                         (deleted_at)
#  index_homes_on_organization_id                    (organization_id)
#  index_homes_on_organization_id_and_finance_order  (organization_id,finance_order) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  test "別組織の班を指定した場合は無効" do
    home = homes(:home1)
    home.section = sections(:section_other_org)

    assert_not home.valid?
    assert_includes home.errors[:section_id], "は同じ組織の班を指定してください。"
  end

  test "土地で使用中の世帯は土地フラグを外せない" do
    home = homes(:home1)
    home.land_flag = false

    assert_not home.valid?
    assert_includes home.errors[:land_flag], "は土地で使用されているため外せません。"
  end

  test "土地で未使用の世帯は土地フラグを外せる" do
    home = Home.new(
      organization: organizations(:org),
      section: sections(:sections0),
      name: "土地外",
      phonetic: "とちがい",
      display_order: 999,
      land_flag: false
    )

    assert home.valid?
  end
end
