class TaskStatus < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "task_status"

  enum_accessor :code

  scope :closed, -> { where(closed_flag: true) }
  scope :open, -> { where(open_flag: true) }
  scope :start, -> { where(start_flag: true) }
  scope :started, -> { where(started_flag: true) }
  scope :workable, -> { where(work_flag: true) }

  def self.closed_ids
    closed.pluck(:id)
  end

  def self.closed_codes
    closed.pluck(:code)
  end

  def self.open_ids
    open.pluck(:id)
  end

  def self.start_ids
    start.pluck(:id)
  end

  def self.started_ids
    started.pluck(:id)
  end

  def self.workable_ids
    workable.pluck(:id)
  end

  def btn_class
    self[:btn_class] || "btn btn-secondary"
  end

  def next_statuses
    TaskStatus.where(id: self[:next_statuses]).order(:id)
  end
end
