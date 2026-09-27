require 'test_helper'
require 'timeout'

class SystemConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    @organization = Organization.create!(name: "年度同時作成テスト", term: 10)
    System.create!(organization_id: @organization.id, term: 10,
                   start_date: Date.new(2026, 1, 1), end_date: Date.new(2026, 3, 31))
  end

  teardown do
    @organization.destroy!
  end

  test "作付計画から同時に次期を作成しても一件だけ保存する" do
    ids = concurrently do
      System.ensure_for_planning!(Organization.find(@organization.id), 11).id
    end

    assert_equal 1, ids.uniq.size
    assert_equal 1, @organization.systems.where(term: 11).count
    assert_equal Date.new(2026, 4, 1), System.find(ids.first).start_date
  end

  test "明示的な短期設定と先行作成が競合しても設定と一意性を維持する" do
    concurrently do |index|
      organization = Organization.find(@organization.id)
      if index.zero?
        organization.with_lock do
          System.init(organization.id, 11, term_name: "短期",
                                           start_date: Date.new(2026, 4, 1), end_date: Date.new(2026, 6, 30)).save!
        end
      else
        System.ensure_for_planning!(organization, 11)
      end
    end

    assert_equal 1, @organization.systems.where(term: 11).count
    system = @organization.systems.find_by!(term: 11)
    assert_equal "短期", system.term_name
    assert_equal Date.new(2026, 6, 30), system.end_date
  end

  private

  def concurrently
    ready = Queue.new
    start = Queue.new
    threads = Array.new(2) do |index|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          start.pop
          yield index
        end
      end
    end
    Timeout.timeout(10) do
      2.times { ready.pop }
      2.times { start << true }
      threads.map(&:value)
    end
  ensure
    threads&.each do |thread|
      thread.kill if thread.alive?
      thread.join
    end
  end
end
