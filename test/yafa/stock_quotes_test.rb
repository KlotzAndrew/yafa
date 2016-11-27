require 'test_helper'

module Yafa
  class StockQuotesTest < Minitest::Test
    def test_returns_stock_quotes
      VCR.use_cassette('yahoo_finance_api') do
        tickers = ['GOOG']
        expected_quote = {
          name: 'Alphabet Inc.',
          last_trade_price_only: '761.68',
          last_trade_time: '1:00pm 25/11/2016'
        }

        quotes = StockQuotes.new.call tickers

        assert_equal 1, quotes.count

        quote = quotes.first
        assert_equal expected_quote[:name],
                     quote[:name]
        assert_equal expected_quote[:last_trade_time],
                     quote[:last_trade_time]
        assert_equal expected_quote[:last_trade_price_only],
                     quote[:last_trade_price_only]
      end
    end

    def test_returns_multiple_stock_quotes
      VCR.use_cassette('yahoo_finance_api') do
        tickers = %w(GOOG YHOO)

        quotes = StockQuotes.new.call tickers

        assert_equal 2, quotes.count
        assert_equal 'Alphabet Inc.', quotes.first[:name]
        assert_equal 'Yahoo! Inc.', quotes.last[:name]
      end
    end
  end
end
