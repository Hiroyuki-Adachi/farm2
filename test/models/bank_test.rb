# == Schema Information
#
# Table name: banks
#
#  code       :string(4)        not null, primary key
#  name       :string(40)       not null
#  phonetic   :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class BankTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
