# == Schema Information
#
# Table name: work_type_terms
#
#  id                     :bigint           not null, primary key
#  bg_color(背景色)       :string(8)
#  term(年度(期))         :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  work_type_terms_2nd  (term,work_type_id) UNIQUE
#
class WorkTypeTerm < ApplicationRecord
  belongs_to :work_type, -> {with_deleted}
end
