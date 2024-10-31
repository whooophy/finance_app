class UsersController < ApplicationController
  def create
    # parsing and validate params from request body
    username = user_params[:username]
    team_id = user_params[:team_id]

    # Check is username already exist or used by another user
    if User.exists?(username: username)
      render json: { error: 'Username already taken. Please choose another username.' }, status: :conflict
      return
    end

    # Check team exists or not
    team = Team.find_by(id: team_id)
    if team.nil?
      render json: { error: 'Selected team does not exist.' }, status: :not_found
      return
    end

    # create new user
    user = User.new(username: username, team: team)

    if user.save
      render json: { message: 'User created successfully', user: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def detail
    user = User.includes(:user_histories).find_by(username: params[:username])

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    render json: {
      username: user.username,
      total_balance: user.balance,
      user_histories: user.user_histories.map { |history|
        {
          txID: history.txID,
          balance_before: history.balance_before,
          balance_after: history.balance_after,
          type: history.type_of,
          created_at: history.created_at
        }
      }
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:username, :team_id)
  end
end
