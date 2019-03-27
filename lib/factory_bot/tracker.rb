require "hirb"

module FactoryBot
  class Tracker
    attr_reader :results

    def initialize
      @results = {}
    end

    def init
      ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |_n, _s, _f, _i, payload|
        factory_name  = payload[:name]
        strategy_name = payload[:strategy]
        @results[factory_name] ||= {}
        @results[factory_name][strategy_name] ||= 0
        @results[factory_name][strategy_name] += 1
      end
    end

    def output
      extend Hirb::Console

      totals = { name: "TOTALS" }
      %i[create build build_stubbed attributes_for].map do |key|
        value = results_hash.reduce(0) { |sum, e| sum += e.fetch(key, 0) }
        totals[key] = value
      end
      all = results_hash + [totals]

      puts "\n"
      table [*all], fields: %i[name create build build_stubbed attributes_for]
    end

    private

    def results_hash
      results.map do |k, v|
        v[:name] = k
        v
      end
    end
  end
end
