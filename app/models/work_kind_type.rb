# == Schema Information
#
# Table name: work_kind_types # 作業種別分類対応マスタ
#
#  id           :integer          not null, primary key # 作業種別分類対応マスタ
#  work_kind_id :integer                                # 作業種別
#  work_type_id :integer                                # 作業分類
#

class WorkKindType < ActiveRecord::Base
  belongs_to :work_kind
  belongs_to :work_type
end
