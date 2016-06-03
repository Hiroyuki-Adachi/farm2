# == Schema Information
#
# Table name: organizations
#
#  id              :integer          not null, primary key
#  show_work1      :string(10)       not null
#  show_work2      :string(10)       not null
#  workers_count   :integer          default(12), not null
#  lands_count     :integer          default(17), not null
#  machines_count  :integer          default(8), not null
#  chemicals_count :integer          default(4), not null
#  daily_worker    :integer          default(0), not null
#  consignor_code  :string(10)
#  consignor_name  :string(40)
#  bank_code       :string(4)        default("0000"), not null
#  branch_code     :string(3)        default("000"), not null
#  account_type_id :integer          default(0), not null
#  account_number  :string(7)        default("0000000"), not null
#  term            :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Organization < ActiveRecord::Base
  enum daily_worker: {no_print: 0, print_home: 1, print_section: 2}

end
