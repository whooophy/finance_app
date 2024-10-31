class TransfersController < ApplicationController
  def create
    source_username = transfer_params[:source]
    destination_username = transfer_params[:destination]
    transfer_amount = transfer_params[:balance].to_d

    source_user = User.find_by(username: source_username)
    destination_user = User.find_by(username: destination_username)

    if source_user.nil? || destination_user.nil?
      render json: { error: 'Source or destination user not found' }, status: :not_found
      return
    end

    if source_user.balance < transfer_amount
      render json: { error: 'Insufficient balance for the transfer' }, status: :unprocessable_entity
      return
    end

    # Create TX ID for transfer
    transfer_txid = "TXTransfer#{Time.now.to_i}"
    receive_txid = "TXReceive#{Time.now.to_i}"

    ActiveRecord::Base.transaction do

      # Check if source and destination are in the same team and apply admin fee if so
      fee = 0.0
      if source_user.team == destination_user.team
        fee = transfer_amount * 0.01  # 1% admin fee

        # Create history for admin fee
        admin_fee_txid = "TXADMINFEE#{Time.now.to_i}"
        UserHistory.create!(
          user: source_user,
          balance_before: source_user.balance,
          balance_after: source_user.balance - fee,
          txID: admin_fee_txid,
          type_of: 'credit'
        )
      end

      # Deduct from source balance
      total_deduction = transfer_amount + fee
      source_user.update!(balance: source_user.balance - total_deduction)

      # deduct team balance
      source_team = source_user.team
      source_team.total_balance -= total_deduction
      source_team.save!

      # Add to destination balance
      destination_user.update!(balance: (destination_user.balance || 0.0) + transfer_amount)
      # add destination team balance
      destination_team = destination_user.team
      destination_team.total_balance += transfer_amount
      destination_team.save!

      # Create user history for transfer
      UserHistory.create!(
        user: source_user,
        balance_before: source_user.balance + total_deduction,
        balance_after: source_user.balance,
        txID: transfer_txid,
        type_of: 'credit'
      )

      # Create user history for receiving with a different TX ID
      UserHistory.create!(
        user: destination_user,
        balance_before: destination_user.balance - transfer_amount,
        balance_after: destination_user.balance,
        txID: receive_txid,
        type_of: 'debit'
      )
    end

    render json: { message: 'Transfer successful', transfer_id: transfer_txid, receive_id: receive_txid }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    logger.error e.message  # Log the error message
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end

  private

  def transfer_params
    params.require(:transfer).permit(:source, :destination, :balance)
  end
end
