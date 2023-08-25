require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/test/fixtures"

  config.include FactoryBot::Syntax::Methods
  config.include RequestSpecHelper, type: :request
end

def generate_unique_email(base_email)
  random_string = SecureRandom.hex(4) # Generate a random string of length 8
  domain = base_email.split('@').last
  modified_email = "#{base_email.gsub('@' + domain, '')}+#{random_string}@#{domain}"
  modified_email.downcase
end
