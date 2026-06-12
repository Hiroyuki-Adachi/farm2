require "test_helper"

class LandHomeTest < ActiveSupport::TestCase
  test "土地フラグが無効な世帯を指定した場合は無効" do
    home = Home.create!(organization: organizations(:org), section: sections(:sections0), name: "土地外", phonetic: "とちがい", display_order: 999, land_flag: false)
    land_home = LandHome.new(land: lands(:lands0), home: home, place: "1", area: 1, owner_flag: true)

    assert_not land_home.valid?
    assert_includes land_home.errors[:home_id], "は土地フラグが有効な世帯を指定してください。"
  end
end
