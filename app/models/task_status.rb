class TaskStatus < ActiveYaml::Base
  include ActiveHash::Enum

  set_root_path "config/master"
  set_filename "task_status"

  enum_accessor :code

  scope :closed, -> { where(closed_flag: true) }
  scope :open, -> { where(closed_flag: false) }

  def self.closed_ids
    closed.pluck(:id)
  end

  def self.open_ids
    open.pluck(:id)
  end

  def btn_class
    self[:btn_class] || "btn btn-secondary"
  end

  def next_statuses
    TaskStatus.where(id: self[:next_statuses])
  end
end
