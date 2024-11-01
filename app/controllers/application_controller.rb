class ApplicationController < ActionController::API
  before_action :authorize_request

  private
  def authorize_request
    unless session[:api_key].present? && session[:expires_at] > Time.current
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
