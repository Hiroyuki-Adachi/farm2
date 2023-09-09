# == Schema Information
#
# Table name: desticides
#
#  id                      :integer          not null, primary key
#  mixed_count(混合数)     :integer          not null
#  name(名称)              :string(100)      not null
#  registed_on(登録年月日) :date
#  type_name(種類)         :string(100)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  form_id(剤型)           :integer          not null
#  maker_id(製造元)        :integer          not null
#  purpose_id(用途)        :integer          not null
#
require "test_helper"

class DesticideTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
