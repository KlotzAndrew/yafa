# Yafa

**Ya**hoo **F**inance **A**PI wrapper, fetch stock quotes and stock 
chart data

### Setup

Just install yafa or add it to your gemfile `gem 'yafa'`

### Usage
#### Quotes data

Fetches the current/most recent stock quote:

```ruby
tickers = ['GOOG']
fetcher = StockQuotes.new(tickers)
quotes  = fetcher.fetch
```

Tickers array takes up to 400 tickers at once

#### Chart data

Fetches per-minute quotes for the last day, good for making charts of
recent stock prices

```ruby
ticker = 'GOOG'
fetcher = StockChart.new(ticker)
chart_data = fetcher.fetch
```

Fetches for a single ticker per request

#### Historical Data

Coming soon...

### Worth knowing
 * Yahoo Finance API sometimes goes down, so handle failed requests
 * Stay under your Yahoo API request limit, something like 20k/day 
 (based on IP address making the request)

### Improvements
 * Historical data api
 * Config for fetcher (i.e. timeouts, query params)
 * Option to replace Yahoo time and key formatting with a consistent 
 format
