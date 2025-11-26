# test/helpers/statistics_helper_test.rb
require "test_helper"

class StatisticsHelperTest < ActionView::TestCase
  include StatisticsHelper

  GenreStub = Struct.new(:id, :combined_name, :graph_color)

  test "default_color=先頭の色" do
    assert_equal COLORS.first, default_color
  end

  test "labels の抽出" do
    total_all = [[1, 10], [2, 20]]
    assert_equal [1, 2], labels(total_all)
  end

  test "tab1_data の抽出" do
    total_all = [[1, 10], [2, 20]]
    assert_equal [10.0, 20.0], tab1_data(total_all)
  end

  test "tab2_datasets の構築" do
    genres = [
      GenreStub.new(1, "Genre A", nil),
      GenreStub.new(2, "Genre B", "#123456")
    ]
    total_all = [[1, 10], [2, 20]]
    total_genre = { [1, 1] => 5, [1, 2] => 8, [2, 1] => 3, [2, 2] => 6 }

    datasets = tab2_datasets(total_all, genres, total_genre)

    assert_equal 2, datasets.size
    assert_equal "Genre A", datasets[0][:label]
    assert_equal [5.0, 8.0], datasets[0][:data]
    assert_equal COLORS[0], datasets[0][:backgroundColor]

    assert_equal "Genre B", datasets[1][:label]
    assert_equal [3.0, 6.0], datasets[1][:data]
    assert_equal "#123456", datasets[1][:backgroundColor]
  end

  def tab3_datasets(total_all, total_age)
    results = []
    t("statistics.age").each_with_index do |age, i|
      results << {
        label: age,
        data: total_all.map {|t| total_age[[t[0], i]].to_f },
        backgroundColor: COLORS[i],
        fill: false
      }
    end
    return results
  end

  test "tab4_datasets の構築" do
    current = (1..12).map { |m| m * 10 }       # [10,20,...120]
    previous = (1..12).map { |m| m * 5 }       # [5,10,...60]
    avg = (1..12).map { |m| m * 7 }            # [7,14,...84]

    datasets = tab4_datasets(current, previous, avg)

    assert_equal 3, datasets.size
    assert_equal current.map(&:to_f),  datasets[2][:data]
    assert_equal previous.map(&:to_f), datasets[1][:data]
    assert_equal avg.map(&:to_f),      datasets[0][:data]
  end
end
