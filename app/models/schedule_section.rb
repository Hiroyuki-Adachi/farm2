# == Schema Information
#
# Table name: schedule_sections(作業予定班)
#
#  schedule_id(作業予定) :integer          not null, primary key
#  section_id(班)        :integer          not null, primary key
#
class ScheduleSection < ApplicationRecord
  self.primary_key = [:schedule_id, :section_id]

  belongs_to :schedule
  belongs_to :section
end
