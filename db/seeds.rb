# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'

organization = Organization.create(
    name: "◯◯営農組合",
    workers_count: 12,
    lands_count: 17,
    machines_count: 8,
    chemicals_count: 4,
    daily_worker: 0,
    consignor_code: '',
    consignor_name: '',
    bank_code: '0000',
    branch_code: '000',
    account_type_id: 0,
    account_number: '0000000',
    term: Date.today.year
)

System.create(
    term: Date.today.year,
    target_from: Date::new(Date.today.year, 1, 1),
    target_to: Date::new(Date.today.year, 12, 31)
)

WorkType.create(
[{
  genre: 1,
  name: "稲作",
  category_flag: true,
  display_order: 1
},{
  genre: 2,
  name: "転作",
  category_flag: true,
  display_order: 2
},{
  genre: 3,
  name: "副産物",
  category_flag: true,
  display_order: 3
},{
  genre: 4,
  name: "共通",
  category_flag: true,
  display_order: 4
}])
