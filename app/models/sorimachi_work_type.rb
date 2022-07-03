# == Schema Information
#
# Table name: sorimachi_work_types
#
#  id                                 :bigint           not null, primary key
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
end
