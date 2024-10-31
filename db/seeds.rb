# db/seeds.rb

# Delete all data to prevent duplication
Team.destroy_all

# create seed datas
teams = [
  { name: 'Team Alpha', total_balance: 1000.00 },
  { name: 'Team Beta', total_balance: 1500.00 },
  { name: 'Team Gamma', total_balance: 2000.00 },
  { name: 'Team Delta', total_balance: 2500.00 }
]

teams.each do |team_data|
  Team.create!(team_data)
end

puts "Created #{Team.count} teams."
