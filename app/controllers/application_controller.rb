# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
end
