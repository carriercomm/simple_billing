class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
