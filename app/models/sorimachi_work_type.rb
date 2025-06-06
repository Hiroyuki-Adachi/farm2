# == Schema Information
#
# Table name: sorimachi_work_types(ソリマチ作業分類)
#
#  id                                 :bigint           not null, primary key
#  amount(内訳金額)                   :decimal(7, )     default(0), not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  sorimachi_journal_id(ソリマチ仕訳) :integer          default(0), not null
#  work_type_id(作業分類)             :integer          default(0), not null
#
# Indexes
#
#  sorimachi_work_types_2nd  (sorimachi_journal_id,work_type_id) UNIQUE
#
class SorimachiWorkType < ApplicationRecord
  belongs_to :sorimachi_journal
  belongs_to :work_type

  def self.refresh(journal_id, params)
    SorimachiWorkType.where(sorimachi_journal_id: journal_id).destroy_all
    return if params.blank?
    params[:amounts].each do |key, value|
      next if value.to_f.zero?
      SorimachiWorkType.create({
                                 sorimachi_journal_id: journal_id,
                                 work_type_id: key,
                                 amount: value
                               })
    end
  end
end
