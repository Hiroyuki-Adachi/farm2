# == Schema Information
#
# Table name: work_lands # 作業地データ
#
#  id            :integer          not null, primary key # 作業地データ
#  work_id       :integer                                # 作業
#  land_id       :integer                                # 土地
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime
#  updated_at    :datetime
#

class WorkLand < ApplicationRecord
  belongs_to :work
  belongs_to :land, -> {with_deleted}
end
