require 'test_helper'

module Yafa
  class StockQuotesTest < Minitest::Test
    def test_returns_stock_quotes
      VCR.use_cassette('yahoo_finance_api') do
        tickers               = ['GOOG']
        name                  = 'Alphabet Inc.'
        last_trade_price_only = '761.68'

        fetcher = StockQuotes.new(tickers)
        quotes  = fetcher.fetch

        assert_equal 1, quotes.count
        assert_equal name, quotes.first['Name']
        assert_equal last_trade_price_only, quotes.first['LastTradePriceOnly']
      end
    end

    def test_returns_multiple_stock_quotes
      VCR.use_cassette('yahoo_finance_api') do
        tickers = %w(GOOG YHOO)

        fetcher = StockQuotes.new(tickers)
        quotes  = fetcher.fetch

        assert_equal 2, quotes.count
        assert_equal 'Alphabet Inc.', quotes.first['Name']
        assert_equal 'Yahoo! Inc.', quotes.last['Name']
      end
    end
  end
end
