# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'

organization = Organization.create!(
  name: "営農組合の名前",
  workers_count: 12,
  lands_count: 17,
  machines_count: 8,
  chemicals_count: 4,
  daily_worker: 0,
  consignor_code: '',
  consignor_name: '',
  term: Date.today.year
)

system = System.create!(
  term: Date.today.year,
  target_from: Date.new(Date.today.year, 1, 1),
  target_to: Date.new(Date.today.year, 12, 31),
  start_date: Date.new(Date.today.year, 1, 1),
  end_date: Date.new(Date.today.year, 12, 31),
  organization_id: organization.id
)

WorkType.create!(
  [{
    genre: 1,
    name: "稲作",
    category_flag: true,
    display_order: 10
  }, {
    genre: 2,
    name: "転作",
    category_flag: true,
    display_order: 20
  }, {
    genre: 3,
    name: "副産物",
    category_flag: true,
    display_order: 30
  }, {
    genre: 4,
    name: "管理",
    category_flag: true,
    display_order: 40
  }]
)
WorkType.create!(
  [{
    genre: 1,
    name: "こしひかり",
    category_flag: false,
    display_order: 11
  }, {
    genre: 2,
    name: "WCS",
    category_flag: false,
    display_order: 21
  }, {
    genre: 3,
    name: "稲わら",
    category_flag: false,
    display_order: 31
  }, {
    genre: 4,
    name: "管理部",
    category_flag: false,
    display_order: 41
  }]
)

section = Section.create!(
  name: "システム部"
)

home = Home.create!(
  phonetic: "しすてむ",
  name: "システム",
  section_id: section.id,
  display_order: 1
)

worker = Worker.create!(
  family_phonetic: "しすてむ",
  family_name: "システム",
  first_phonetic: "たろう",
  first_name: "太郎",
  display_order: 1,
  home_id: home.id
)

home.update(worker_id: worker.id)

User.create!(
  login_name: "system",
  password: "SYSTEM",
  password_confirmation: "SYSTEM",
  worker_id: worker.id,
  term: system.term,
  target_from: system.target_from,
  target_to: system.target_to,
  organization_id: organization.id,
  permission_id: :admin
)
