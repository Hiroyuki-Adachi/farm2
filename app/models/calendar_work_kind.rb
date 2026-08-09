# == Schema Information
#
# Table name: calendar_work_kinds(カレンダー作業種別)
#
#  id                     :bigint           not null, primary key
#  text_color(文字色)     :string(8)        default("#000000"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id(利用者)        :integer          not null
#  work_kind_id(作業種別) :integer          not null
#
# Indexes
#
#  calendar_work_kind_index  (user_id,work_kind_id) UNIQUE
#

class CalendarWorkKind < ApplicationRecord
  belongs_to :user
  belongs_to :work_kind

  scope :for_organization, ->(organization) { joins(:user).merge(User.for_organization(organization)) }
  scope :usual, ->(user) { where(user_id: user) }

  def self.regist(user, params)
    calendar_work_kinds = user.calendar_work_kinds
    work_kinds = []
    unless params[:work_kind_id]
      calendar_work_kinds.find_each(&:destroy)
      return
    end
    params[:work_kind_id].each do |work_kind_id|
      calendar_work_kind = calendar_work_kinds.find_by(work_kind_id: work_kind_id)
      work_kinds << work_kind_id.to_i
      text_color = params[:text_color][work_kind_id]
      if calendar_work_kind
        calendar_work_kind.update(text_color: text_color) if calendar_work_kind.text_color != text_color
      else
        calendar_work_kinds.create(work_kind_id: work_kind_id, text_color: text_color)
      end
    end
    calendar_work_kinds.where.not(work_kind_id: work_kinds).find_each(&:destroy)
  end

  def excel_color
    text_color.delete('#')
  end
end
