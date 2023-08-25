# Load the Rails environment
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/test/fixtures"
end

def generate_unique_email(base_email)
  random_string = SecureRandom.hex(4) # Generate a random string of length 8
  domain = base_email.split('@').last
  modified_email = "#{base_email.gsub('@' + domain, '')}+#{random_string}@#{domain}"
  modified_email.downcase
end
