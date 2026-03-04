require 'test_helper'

class ParsesCrawlDateTest < ActiveSupport::TestCase
  class DummyParser
    include ParsesCrawlDate
  end

  setup do
    @parser = DummyParser.new
  end

  test 'yyyy年m月d日 をパースできる' do
    assert_equal Date.new(2025, 4, 9), @parser.parse_crawl_date('2025年4月9日')
  end

  test 'yyyy/mm/dd をパースできる' do
    assert_equal Date.new(2025, 4, 8), @parser.parse_crawl_date('2025/04/08')
  end

  test 'yyyy-mm-dd hh:mm:ss をパースできる' do
    assert_equal Date.new(2025, 3, 7), @parser.parse_crawl_date('2025-03-07 10:00:00')
  end

  test '和暦をパースできる' do
    assert_equal Date.new(2025, 6, 13), @parser.parse_crawl_date('令和7年6月13日')
  end

  test '文中の日付を抽出してパースできる' do
    assert_equal Date.new(2024, 10, 21), @parser.parse_crawl_date('公開日: 2024.10.21 更新')
  end

  test '不正な文字列は nil を返す' do
    assert_nil @parser.parse_crawl_date('公開日: 未定')
  end
end
