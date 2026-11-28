FactoryBot.define do
  factory :organization do
    name { "単価計算専用" }
    term { 2015 }

    # 実際の組織と同じく当期の年度(System)を持たせる。作業日の期内検証(#1351)が年度を引くため。
    after(:create) do |organization|
      next if organization.term.blank? || System.exists?(organization_id: organization.id, term: organization.term)

      System.create!(organization_id: organization.id, term: organization.term,
                     start_date: Date.new(organization.term, 1, 1), end_date: Date.new(organization.term, 12, 31))
    end
  end
end
