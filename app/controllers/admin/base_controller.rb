class Admin::BaseController < ApplicationController
  layout 'backend'
  before_action :authenticate_user!
  before_action :authenticate_admin
end