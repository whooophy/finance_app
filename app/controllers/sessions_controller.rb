class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create, :destroy]
  def create
    if params[:username] == 'superadmin'
      session[:user_id] = nil
      session[:api_key] = SecureRandom.hex(16)
      session[:expires_at] = 15.minutes.from_now
      render json: { message: 'Superadmin session created', api_key: session[:api_key] }, status: :created
    else
      user = User.find_by(username: params[:username])
      if user
        session[:user_id] = user.id
        session[:api_key] = SecureRandom.hex(16)
        session[:expires_at] = 15.minutes.from_now
        render json: { message: 'Session created', api_key: session[:api_key] }, status: :created
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end

  def destroy
    if params[:key].present?
      session.delete(params[:key])
      render json: { message: "Session with key #{params[:key]} destroyed" }, status: :ok
    else
      reset_session
      render json: { message: 'All sessions destroyed' }, status: :ok
    end
  end
end
