# == Schema Information
#
# Table name: sorimachi_accounts
#
#  id               :bigint           not null, primary key
#  code(科目コード) :integer          default(0), not null
#  name(名称)       :string           default(""), not null
#  term(年度(期))   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  sorimachi_accounts_2nd  (term,code) UNIQUE
#
class SorimachiAccount < ApplicationRecord
end
