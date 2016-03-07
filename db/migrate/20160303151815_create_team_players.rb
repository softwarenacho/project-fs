class CreateTeamPlayers < ActiveRecord::Migration
  def change
    create_table :team_players do |m|
      m.integer   "player_id"
      m.integer   "team_id"
      m.string    "position"
      m.integer   "goals", default: 0
      m.integer   "assists", default: 0
      m.integer   "r_cards", default: 0
      m.integer   "faults", default: 0
      m.integer   "y_cards", default: 0
      m.integer   "r_cards", default: 0
      m.integer   "pass_success", default: 0
      m.integer   "pass_total", default: 0
      m.integer   "shot_success", default: 0
      m.integer   "shot_total", default: 0 
      m.integer   "tackle_success", default: 0
      m.string    "tackle_total", default: 0
      m.string    "goals_conceded", default: 0
      m.string    "goals_blocked", default: 0
      m.timestamps null:false
    end
  end
end