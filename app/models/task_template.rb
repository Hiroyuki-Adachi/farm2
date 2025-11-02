# == Schema Information
#
# Table name: task_templates(定型タスク)
#
#  id                              :bigint           not null, primary key
#  active(有効)                    :boolean          default(TRUE), not null
#  annual_month(期日月)            :integer
#  description(説明)               :text             default(""), not null
#  discarded_at(論理削除日時)      :datetime
#  kind(年次/月次)                 :integer          default("annual"), not null
#  monthly_stage(期日週)           :integer          default("w1")
#  months_before_due(事前通知月数) :integer          default(1)
#  office_role(役割)               :integer          default("none"), not null
#  offset(基準からのズレ)          :integer          default(0)
#  priority(優先度)                :integer          default("low"), not null
#  title(タスク名)                 :string(40)       not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  organization_id(組織ID)         :bigint           not null
#
# Indexes
#
#  idx_on_kind_annual_month_monthly_stage_5eb8d135fc  (kind,annual_month,monthly_stage)
#  index_task_templates_on_organization_id            (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class TaskTemplate < ApplicationRecord
  include Enums::OfficeRole
  include Discard::Model

  enum :priority, { low: 0, medium: 5, high: 8 }
  enum :kind, { annual: 0, monthly: 1, any_time: 9 }, prefix: true
  enum :monthly_stage, { w1: 0, w2: 7, w3: 14, w4: 21, month_end: 31 }

  has_many :tasks, dependent: :restrict_with_error
  belongs_to :organization

  validates :title, presence: true, length: { maximum: 40 }
  validates :months_before_due, inclusion: { in: 0..6 }
  validates :annual_month, inclusion: { in: 1..12 }, if: :kind_annual?
  validates :offset, inclusion: { in: [-1, 0, 1] }

  attr_writer :annual_offset, :monthly_offset

  before_save :clear_annual_month_fields, if: :kind_monthly?
  before_save :set_offset

  scope :usual, -> { with_discarded.order(active: :desc, id: :desc) }
  scope :for_creation, -> { kept.where(active: true) }

  # 指定年月の期日(due_on)を計算
  def due_on_for(year:, month:)
    base = Date.new(year, month, 1)
    day =
      case monthly_stage.to_sym
      when :month_end
        base.end_of_month.day
      else
        nth_saturday_day(base.year, base.month, stage_to_n(monthly_stage))
      end
    Date.new(base.year, base.month, day)
  end

  # 今日が生成基準日に当たる due_on 候補を返す
  # 生成基準日 = (due_on - months_before_due.months)
  def due_on_candidates_for(today:)
    list = []
    targets =
      if kind_monthly?
        # 今月/来月の2候補を見れば十分
        [today.beginning_of_month, (today.beginning_of_month >> 1)]
      else
        # 年次は annual_month を使用（今年/来年分を見る）
        return list unless annual_month
        [Date.new(today.year, annual_month, 1),
         Date.new(today.year + 1, annual_month, 1)]
      end

    targets.each do |base|
      due_on = due_on_for(year: base.year, month: base.month)
      anchor = due_on << months_before_due
      list << due_on if anchor == today
    end
    list
  end

  def destroy_or_archive!
    if tasks.exists?
      update!(active: false)
      discard unless discarded?
    else
      destroy!
    end
  end

  def create_task(due_on:)
    return nil if discarded?
    return nil unless active?
    return nil if same_task_exists?(due_on: due_on)

    title_date = due_on + (kind_annual? ? offset.years : offset.months)
    task_title = 
      if kind_annual?
        "【#{title_date.strftime('%Jy年')}】#{title}"
      else
        "【#{title_date.strftime('%Jy年%m月')}】#{title}"
      end
    
    return Task.create!(
      title: task_title,
      description: description,
      due_on: due_on,
      priority: priority,
      office_role: office_role,
      task_status_id: TaskStatus::TO_DO.id,
      template: self
    )
  end

  def same_task_exists?(due_on:)
    return tasks.exists?(due_on: due_on.all_month) if self.kind_monthly?

    target_system = System.get_system(due_on, organization_id)
    return true unless target_system

    return tasks.exists?(due_on: target_system.start_date..target_system.end_date)
  end

  def annual_offset
    self.offset
  end

  def monthly_offset
    self.offset
  end

  private

  def stage_to_n(stage)
    { w1: 1, w2: 2, w3: 3, w4: 4 }[stage.to_sym]
  end

  def nth_saturday_day(year, month, num)
    first = Date.new(year, month, 1)
    # 最初の土曜
    first_sat = first + ((6 - first.wday) % 7)
    (first_sat + (7 * (num - 1))).day
  end

  def clear_annual_month_fields
    self.annual_month = nil
    self.months_before_due = 1
  end

  def set_offset
    self.offset = kind_annual? ? @annual_offset.to_i : @monthly_offset.to_i
  end
end
