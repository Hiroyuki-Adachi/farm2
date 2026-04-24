# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'

if ENV['SKIP_SEED'] == 'true' || ENV['SKIP_SEEDS'] == 'true'
  puts 'Skipping seeds because SKIP_SEED/SKIP_SEEDS is true'
  return
end

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
  start_date: Date.new(Date.today.year, 1, 1),
  end_date: Date.new(Date.today.year, 12, 31),
  organization_id: organization.id
)

genre_names = %w[稲作 転作 副産物 管理]
genres = {}

genre_names.each_with_index do |name, index|
  order = (index + 1) * 10
  category = WorkCategory.find_or_create_by!(name: name) do |record|
    record.display_order = order
  end
  genres[name] = WorkGenre.find_or_create_by!(name: name, work_category_id: category.id) do |record|
    record.display_order = order
    record.graph_color = '#ffffff'
  end
end

[
  { genre_name: "稲作", name: "こしひかり", display_order: 11 },
  { genre_name: "転作", name: "WCS", display_order: 21 },
  { genre_name: "副産物", name: "稲わら", display_order: 31 },
  { genre_name: "管理", name: "管理部", display_order: 41 }
].each do |attrs|
  WorkType.find_or_create_by!(
    name: attrs[:name],
    work_genre_id: genres.fetch(attrs[:genre_name]).id
  ) do |record|
    record.display_order = attrs[:display_order]
  end
end

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
  organization_id: organization.id,
  permission_id: :admin
)
