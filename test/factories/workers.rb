# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                        :integer          not null, primary key
#  account_holder_name(口座氏名(半角カナ)) :string(30)       default(""), not null
#  account_number(口座番号)                :string(7)        default("0000000"), not null
#  bank_code(銀行コード)                   :string(4)        default("0000"), not null
#  birthday(誕生日)                        :date
#  branch_code(支店コード)                 :string(3)        default("000"), not null
#  broccoli_mark(ブロッコリ記号)           :string(1)
#  deleted_at                              :datetime
#  display_order(表示順)                   :integer
#  family_name(姓)                         :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))              :string(15)       not null
#  first_name(名)                          :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))               :string(15)       not null
#  mobile(携帯番号)                        :string(15)
#  mobile_mail(メールアドレス(携帯))       :string(50)
#  office_role(事務の役割)                 :integer          default("none"), not null
#  pc_mail(メールアドレス(PC))             :string(50)
#  work_flag(作業フラグ)                   :boolean          default(TRUE), not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  account_type_id(口座種別)               :integer          default("unset"), not null
#  gender_id(性別)                         :integer          default("none"), not null
#  home_id(世帯)                           :integer
#  organization_id(組織)                   :bigint           default(1), not null
#  position_id(役職)                       :integer          default("none"), not null
#
# Indexes
#
#  index_workers_on_deleted_at       (deleted_at)
#  index_workers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
FactoryBot.define do
  factory :worker do
    home
    organization { home.organization }
    family_name { "単価" }
    first_name { "計算" }
    family_phonetic { "たんか" }
    first_phonetic { "けいさん" }
    display_order { 1 }
    work_flag { false }
  end
end
