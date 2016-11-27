$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yafa'
require 'vcr'

require 'minitest/autorun'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = {
    match_requests_on: [:uri],
    record:            :new_episodes
  }
end
