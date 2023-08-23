class ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent
  include SessionsHelper
end
