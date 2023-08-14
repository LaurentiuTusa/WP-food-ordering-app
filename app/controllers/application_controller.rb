class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  include SessionsHelper
end
