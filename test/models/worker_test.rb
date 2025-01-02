# == Schema Information
#
# Table name: workers
#
#  id(作業者マスタ)                  :integer          not null, primary key
#  account_number(口座番号)          :string(7)        default("0000000"), not null
#  bank_code(口座(金融機関))         :string(4)        default("0000"), not null
#  birthday(誕生日)                  :date
#  branch_code(口座(支店))           :string(3)        default("000"), not null
#  broccoli_mark(ブロッコリ記号)     :string(1)
#  deleted_at                        :datetime
#  display_order(表示順)             :integer
#  family_name(姓)                   :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))   :string(15)       not null
#  first_name(名)                    :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))    :string(15)       not null
#  mobile(携帯番号)                  :string(15)
#  mobile_mail(メールアドレス(携帯)) :string(50)
#  pc_mail(メールアドレス(PC))       :string(50)
#  work_flag(作業フラグ)             :boolean          default(TRUE), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  account_type_id(口座種別)         :integer          default(0), not null
#  gender_id(性別)                   :integer          default(0), not null
#  home_id(世帯)                     :integer
#  position_id(役職)                 :integer          default(0), not null
#
# Indexes
#
#  index_workers_on_deleted_at  (deleted_at)
#
require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  setup do
    @worker = workers(:worker2)
  end

  test "メールアドレス設定" do
    @worker.pc_mail = "worker2@example.com"
    @worker.save!

    assert_equal @worker.pc_mail, @worker.user.email
    assert_not_equal '', @worker.user.google_salt
    assert_not_nil @worker.user.google_secret

    @worker.pc_mail = ''
    @worker.save!

    assert_equal '', @worker.user.email
    assert_nil @worker.user.google_secret
  end
end
