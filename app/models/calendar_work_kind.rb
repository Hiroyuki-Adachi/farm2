# == Schema Information
#
# Table name: calendar_work_kinds # カレンダー作業種別
#
#  id           :bigint           not null, primary key
#  user_id      :integer          not null                     # 利用者
#  work_kind_id :integer          not null                     # 作業種別
#  text_color   :string(8)        default("#000000"), not null # 文字色
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CalendarWorkKind < ApplicationRecord
  belongs_to :user
  belongs_to :work_kind

  scope :usual, ->(user) {where(user_id: user)}

  def self.regist(user_id, params)
    work_kinds = []
    unless params[:work_kind_id]
      CalendarWorkKind.where(user_id: user_id).find_each(&:destroy)
      return
    end
    params[:work_kind_id].each do |work_kind_id|
      calendar_work_kind = CalendarWorkKind.find_by(user_id: user_id, work_kind_id: work_kind_id)
      work_kinds << work_kind_id.to_i
      if calendar_work_kind
        calendar_work_kind.update(text_color: params[:text_color][work_kind_id]) if calendar_work_kind.text_color != params[:text_color][work_kind_id]
      else
        CalendarWorkKind.create(user_id: user_id, work_kind_id: work_kind_id, text_color: params[:text_color][work_kind_id])
      end
    end
    CalendarWorkKind.where(user_id: user_id).where.not(work_kind_id: work_kinds).find_each(&:destroy)
  end
end
