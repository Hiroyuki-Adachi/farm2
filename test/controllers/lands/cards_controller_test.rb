require 'test_helper'

class Lands::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "土地カルテ(一覧)" do
    get lands_cards_path
    assert_response :success
  end

  test "土地カルテ(通常の1年の期は前期の期首から表示する)" do
    land = create_card_land(organizations(:org), homes(:home1))
    create_card_work(land, Date.new(2015, 12, 31))
    create_card_work(land, Date.new(2016, 1, 1))

    get lands_card_path(land_id: land.id)

    assert_response :success
    assert_card_dates(shown: [Date.new(2016, 1, 1)], hidden: [Date.new(2015, 12, 31)])
  end

  test "土地カルテ(短い期の翌期は暦の1年前ではなく前期の期首から表示する)" do
    organization = organizations(:org)
    create_card_system(organization, 2018, Date.new(2018, 1, 1), Date.new(2018, 3, 31))
    create_card_system(organization, 2019, Date.new(2018, 4, 1), Date.new(2019, 3, 31))
    land = create_card_land(organization, homes(:home1))
    create_card_work(land, Date.new(2017, 4, 1))
    create_card_work(land, Date.new(2017, 12, 31))
    create_card_work(land, Date.new(2018, 1, 1))

    get lands_card_path(land_id: land.id)

    assert_response :success
    assert_card_dates(shown: [Date.new(2018, 1, 1)], hidden: [Date.new(2017, 4, 1), Date.new(2017, 12, 31)])
  end

  test "土地カルテ(前期がなければ当期の期首から表示する)" do
    login_as(users(:user_admin_org2))
    land = create_card_land(organizations(:org2), homes(:home_other_org))
    create_card_work(land, Date.new(2014, 6, 1))
    create_card_work(land, Date.new(2015, 1, 1))

    get lands_card_path(land_id: land.id)

    assert_response :success
    assert_card_dates(shown: [Date.new(2015, 1, 1)], hidden: [Date.new(2014, 6, 1)])
  end

  test "土地カルテ(別組織に同じ期番号の期があっても自組織の前期の期首から表示する)" do
    login_as(users(:user_admin_org2))
    organization = organizations(:org2)
    # 組織2は2015期の次を2017期にする。組織で絞らないと、組織1の2016期（期首2016-01-01）が前期になる。
    create_card_system(organization, 2017, Date.new(2016, 1, 1), Date.new(2016, 12, 31))
    assert System.exists?(organization_id: organizations(:org).id, term: 2016)
    land = create_card_land(organization, homes(:home_other_org))
    create_card_work(land, Date.new(2014, 12, 31))
    create_card_work(land, Date.new(2015, 6, 1))

    get lands_card_path(land_id: land.id)

    assert_response :success
    assert_card_dates(shown: [Date.new(2015, 6, 1)], hidden: [Date.new(2014, 12, 31)])
  end

  test "土地カルテ(別組織の土地は表示しない)" do
    land = create_card_land(organizations(:org2), homes(:home_other_org))

    get lands_card_path(land_id: land.id)

    assert_response :not_found
  end

  private

  def create_card_system(organization, term, start_date, end_date)
    System.create!(organization_id: organization.id, term: term, start_date: start_date, end_date: end_date)
  end

  def create_card_land(organization, owner)
    FactoryBot.create(:land, organization: organization, owner: owner, place: "カルテ確認")
  end

  def create_card_work(land, worked_at)
    work = FactoryBot.create(:work, organization: land.organization, work_kind: work_kinds(:work_kind_taue),
                                    worked_at: worked_at, term: worked_at.year)
    FactoryBot.create(:work_land, work: work, land: land)
  end

  def assert_card_dates(shown:, hidden:)
    dates = css_select("tbody tr td:first-child").map { |td| td.text.strip.first(10) }
    shown.each { |date| assert_includes dates, date.to_s }
    hidden.each { |date| assert_not_includes dates, date.to_s }
  end
end
