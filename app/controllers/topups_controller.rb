class TopupsController < ApplicationController
  def create
    # parsing params from json body
    username = topup_params[:username]
    total_balance = topup_params[:total_balance].to_d

    # check user is exist
    user = User.find_by(username: username)
    if user.nil?
      render json: { error: 'Username not found' }, status: :not_found
      return
    end

    # declare database transaction
    ActiveRecord::Base.transaction do
      # get balance user before topup
      balance_before = user.balance || 0.0

      # add balance user
      user.balance = (user.balance || 0.0) + total_balance
      user.save!

      # create user history
      txid = "TXTOPUP#{Time.now.to_i}"
      p txid
      UserHistory.create!(
        user: user,
        balance_before: balance_before,
        balance_after: user.balance,
        txID: txid,
        type_of: 'debit'
      )

      # add team balance
      team = user.team
      team.total_balance += total_balance
      team.save!
    end

    render json: { message: 'Topup successful', new_balance: user.balance }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    p e.message
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end

  private
  def topup_params
    params.require(:topup).permit(:username, :total_balance)
  end

end


