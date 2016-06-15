# == Schema Information
#
# Table name: fixes
#
#  term            :integer          default(0), not null, primary key
#  fixed_at        :date             not null, primary key
#  works_count     :integer          not null
#  hours           :integer          not null
#  works_amount    :decimal(8, )     not null
#  machines_amount :decimal(8, )     not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class FixTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
