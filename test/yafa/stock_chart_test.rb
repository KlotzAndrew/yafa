require 'test_helper'

module Yafa
  class StockChartTest < Minitest::Test
    def test_returns_chart_data
      VCR.use_cassette('yahoo_finance_chart_api') do
        ticker = 'GOOG'

        fetcher = StockChart.new(ticker)
        chart_data = fetcher.fetch

        assert_equal 207, chart_data['series'].size
      end
    end
  end
end
