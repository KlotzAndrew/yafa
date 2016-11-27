require 'open-uri'
require 'json'

module Yafa
  class StockChart
    YAHOO_CHART_API = 'http://chartapi.finance.yahoo.com/instrument/1.0/'\
                      'yahoo_ticker/chartdata;type=quote;range=1d/json'.freeze
    READ_TIMEOUT    = 5
    DATA_SOURCE     = 'yahoo_chart_api'.freeze

    def call(ticker)
      get_bars_data(ticker)
    end

    private

    def get_bars_data(ticker)
      quote_data = call_api ticker
      parse_quote quote_data
    end

    def call_api(ticker)
      url      = format_api_url ticker
      response = perform_api_request url

      response.read
    end

    def perform_api_request(url)
      open(
        url,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
        read_timeout:    READ_TIMEOUT
      )
    end

    def format_api_url(yahoo_ticker)
      YAHOO_CHART_API.sub('yahoo_ticker', yahoo_ticker)
    end

    def parse_quote(data)
      json_string = data.split json_regex_match
      JSON.parse json_string[1]
    end

    def json_regex_match
      /\(|\)/
    end
  end
end
