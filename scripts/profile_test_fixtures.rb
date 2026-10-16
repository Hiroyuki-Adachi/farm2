# Run in a fresh process; never overlap processes using the same test database.
ENV['RAILS_ENV'] ||= 'test'
raise 'Tests must run with RAILS_ENV=test' unless ENV['RAILS_ENV'] == 'test'

require 'json'
require 'benchmark'

module FixtureProfile
  STARTED_AT = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  COMMAND = [$PROGRAM_NAME, *ARGV].freeze
  # Accumulate measurements for the lifetime of this process.
  LOADS = [] # rubocop:disable Style/MutableConstant
  FACTORIES = Hash.new { |hash, key| hash[key] = { calls: 0, seconds: 0.0 } }

  module Loading
    private

    def load_fixtures(...)
      loaded = nil
      elapsed = Benchmark.realtime { loaded = super }
      FixtureProfile::LOADS << { test_class: self.class.name, tables: self.class.fixture_table_names.size,
                                 rows: loaded.values.sum(&:size), seconds: elapsed }
      loaded
    end
  end
end

$LOAD_PATH.unshift(File.expand_path('../test', __dir__))
require 'test_helper'
ActiveSupport.on_load(:active_support_test_case) { prepend FixtureProfile::Loading }
ActiveSupport::Notifications.subscribe('factory_bot.run_factory') do |event|
  metric = FixtureProfile::FACTORIES[event.payload[:strategy]]
  metric[:calls] += 1
  metric[:seconds] += event.duration / 1000.0
end

# Baseline comparison uses identical factory definitions and test cases.
if ENV['FIXTURE_PROFILE_ALL'] == '1'
  require_relative '../test/decorators/statistics/machine_decorator_test'
  Statistics::MachineDecoratorTest.fixture_table_names = ActiveSupport::TestCase.fixture_table_names.dup
  Statistics::MachineDecoratorTest.fixture_sets = ActiveSupport::TestCase.fixture_sets.dup
end

Minitest.after_run do
  report = {
    ruby: RUBY_DESCRIPTION, rails: Rails.version,
    database: ActiveRecord::Base.connection.select_value('SELECT version()'),
    revision: `git rev-parse HEAD`.strip, command: FixtureProfile::COMMAND,
    baseline_all: ENV['FIXTURE_PROFILE_ALL'] == '1', seed: Minitest.seed,
    elapsed_seconds: Process.clock_gettime(Process::CLOCK_MONOTONIC) - FixtureProfile::STARTED_AT,
    fixture_loads: FixtureProfile::LOADS, factories: FixtureProfile::FACTORIES
  }
  puts "FIXTURE_PROFILE=#{JSON.generate(report)}"
end

ARGV.unshift('test')
load File.expand_path('../bin/rails', __dir__)
