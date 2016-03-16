class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |p|
      # DATOS GENERALES
      p.string "name"
      p.string "first_name"
      p.string "last_name"
      p.string "position"
      p.integer "age"
      p.integer "fifa_id"
      p.integer "rating"

      #GET THIS DATA
      p.integer "market_value"

      # DATOS ILUSTRATIVOS
      p.string "avatar"
      p.string "league"
      p.string "nation"
      p.string "nation_img"
      p.string "club"
      p.string "club_img"

      # TRAITS (ARRAY)
      p.float "zen_aggresive"
      p.float "individual_collab"
      p.float "simple_elegant"

      # ATRIBUTOS PRINCIPALES
      p.integer "g_pacing"
      p.integer "g_shooting"
      p.integer "g_passing"
      p.integer "g_dribbling"
      p.integer "g_defense"
      p.integer "g_physical"

      # ATRIBUTOS SECUNDARIOS
      p.integer "acceleration"
      p.integer "aggression"
      p.integer "agility"
      p.integer "balance"
      p.integer "ballcontrol"
      p.integer "skillMoves"
      p.integer "crossing"
      p.integer "curve"
      p.integer "dribbling"
      p.integer "finishing"
      p.integer "freekickaccuracy"
      p.integer "gkdiving"
      p.integer "gkhandling"
      p.integer "gkkicking"
      p.integer "gkpositioning"
      p.integer "gkreflexes"
      p.integer "headingaccuracy"
      p.integer "interceptions"
      p.integer "jumping"
      p.integer "longpassing"
      p.integer "longshots"
      p.integer "marking"
      p.integer "penalties"
      p.integer "positioning"
      p.integer "potential"
      p.integer "reactions"
      p.integer "shortpassing"
      p.integer "shotpower"
      p.integer "slidingtackle"
      p.integer "sprintspeed"
      p.integer "standingtackle"
      p.integer "stamina"
      p.integer "strength"
      p.integer "vision"
      p.integer "volleys"

    end
  end
end
