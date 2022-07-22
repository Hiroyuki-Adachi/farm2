# == Schema Information
#
# Table name: sorimachi_accounts
#
#  id                                  :bigint           not null, primary key
#  auto_code(自動設定コード)           :integer
#  code(科目コード)                    :integer          default(0), not null
#  name(名称)                          :string           default(""), not null
#  term(年度(期))                      :integer          not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  auto_work_type_id(自動設定作業分類) :integer
#  total_cost_type_id(原価種別)        :integer          default(0), not null
#
# Indexes
#
#  sorimachi_accounts_2nd  (term,code) UNIQUE
#
class SorimachiAccount < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to_active_hash :total_cost_type, optional: true

  def self.import(term)
    accounts = open('test/fixtures/sorimachi_accounts.yml', 'r') {|f| YAML.load(f)}
    accounts.each do |key, value|
      account = SorimachiAccount.find_by(term: term, code: value['code'])
      if account
        value.delete_if {|v| ['term', 'code'].include?(v) }
        account.attributes = value
      else
        account = SorimachiAccount.new(value)
        account.term = term
      end
      account.save!
    end
  end

  def self.to_h(term)
    SorimachiAccount.where(term: term).map {|a| [a.code, a.name]}.to_h
  end

  def sales?
    self.total_cost_type == TotalCostType::SALES
  end
end