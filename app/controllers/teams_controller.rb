class TeamsController < ApplicationController
  def index
    teams = Team.select(:id, :name, :total_balance).order(:id)

    render json: teams.map { |team| { id: team.id, name: team.name, total_balance: team.total_balance } }, status: :ok
  end

  def detail
    team = Team.includes(:users).find_by(id: params[:id])

    if team.nil?
      render json: { error: 'Team not found' }, status: :not_found
      return
    end

    render json: {
      team_name: team.name,
      total_balance: team.total_balance,
      users: team.users.map { |user| { username: user.username, balance: user.balance } }
    }, status: :ok
  end
end
