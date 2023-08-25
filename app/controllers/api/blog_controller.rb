class Api::BlogController < Api::ApplicationController
  def index
    respond_to do |format|
      format.html do
        render action: :index
      end
    end
  end
end