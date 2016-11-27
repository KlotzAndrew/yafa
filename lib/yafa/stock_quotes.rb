require 'open-uri'
require 'json'

# inputs ["ticker1", "ticker2"], returns [{quote1_hash}, {quote2_hash}]
module Yafa
  class StockQuotes
    GENERAL_ERROR_MESSAGE = 'Unable to fetch latest quotes!'.freeze

    BATCHLIMIT_QUOTES = 400
    READ_TIMEOUT      = 10
    DEFAULT_TIME_ZONE = 'Eastern Time (US & Canada)'.freeze

    YAHOO_API_START = 'https://query.yahooapis.com/'.freeze
    YAHOO_API_QUERY = 'v1/public/yql?q=SELECT * FROM yahoo.finance.quotes'\
                        ' WHERE symbol IN (yahoo_tickers)'.freeze
    YAHOO_API_END   = '&format=json&diagnostics=true&env=store%3A%2F%2Fdatata'\
                        'bles.org%2Falltableswithkeys&callback='.freeze

    def call(tickers)
      fetch_quotes_from_api tickers
    end

    private

    def fetch_quotes_from_api(tickers)
      formatted_tickers = format_tickers tickers
      quote_data        = call_api(formatted_tickers)

      format_quote_data(quote_data)
    end

    def call_api(yahoo_tickers)
      url      = format_api_url yahoo_tickers
      response = open(
        url,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, read_timeout: READ_TIMEOUT
      )

      response.read
    end

    def format_tickers(tickers)
      tickers.map { |x| "'" + x + "'" }.join(', ')
    end

    def format_api_url(yahoo_tickers)
      yql_query_body = build_yql_query_body(yahoo_tickers)
      [YAHOO_API_START, yql_query_body, YAHOO_API_END].join('')
    end

    def build_yql_query_body(yahoo_tickers)
      url = YAHOO_API_QUERY.gsub('yahoo_tickers', yahoo_tickers)
      URI.encode(url)
    end

    def format_quote_data(quote_data)
      response_data = parse_quote_json(quote_data)
      response_data = wrap(response_data)

      response_data.inject([]) do |stocks_array, stock_hash|
        stocks_array << build_quote(stock_hash) unless stock_hash['Name'].nil?
      end
    end

    def parse_quote_json(message)
      response_data = JSON.parse(message)
      response_data['query']['results']['quote']
    end

    def build_quote(stock_hash)
      {
        symbol:                stock_hash['symbol'],
        name:                  stock_hash['Name'],
        last_trade_price_only: stock_hash['LastTradePriceOnly'],
        stock_exchange:        stock_hash['StockExchange'],
        last_trade_time:       format_last_trade_time(stock_hash)
      }
    end

    def format_last_trade_time(stock_hash)
      d_m_y    = format_month_day_year(stock_hash)
      hrs_mins = format_hour_minute(stock_hash)
      date     = "#{hrs_mins} #{d_m_y}"

      # Time.use_zone(DEFAULT_TIME_ZONE) { Time.zone.parse(date) }.iso8601
      date
    end

    def format_month_day_year(stock_hash)
      m_d_y = stock_hash['LastTradeDate'].split('/')
      [m_d_y[1], m_d_y[0], m_d_y[2]].join('/')
    end

    def format_hour_minute(stock_hash)
      stock_hash['LastTradeWithTime'].split.first
    end

    def wrap(obj)
      return obj if obj.class == Array
      [obj]
    end
  end
end
