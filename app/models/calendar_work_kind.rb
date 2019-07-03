# == Schema Information
#
# Table name: calendar_work_kinds # カレンダー作業種別
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer          not null                     # 利用者
#  work_kind_id :integer          not null                     # 作業種別
#  text_color   :string(8)        default("#000000"), not null # 文字色
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CalendarWorkKind < ApplicationRecord
end
