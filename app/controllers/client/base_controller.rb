class Client::BaseController < ApplicationController
  layout 'client'

  before_action :authenticate_user!
end
