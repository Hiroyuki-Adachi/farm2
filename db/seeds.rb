# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'

Organization.create(
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
    term: 2016,
    target_from: Date::new(Date.today.year, 1, 1),
    target_to: Date::new(Date.today.year, 12, 31)
)