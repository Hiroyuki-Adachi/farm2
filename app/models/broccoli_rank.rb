# == Schema Information
#
# Table name: broccoli_ranks # ブロッコリ等級マスタ
#
#  id            :integer          not null, primary key # ブロッコリ等級マスタ
#  display_name  :string(10)       default(""), not null # 表示名
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BroccoliRank < ActiveRecord::Base
end
