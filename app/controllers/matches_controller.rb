class MatchesController < ApplicationController
  def zero
    puts "ENTRE A ZERO"
    local = []
    visitor = []
    local_players = TeamPlayer.where(team_id: 1)
    visitor_players = TeamPlayer.where(team_id: 3)
    local_players.each do |p|
      temp_player = []
      temp_player << Player.find_by(fifa_id: p.player_id)
      temp_player << p.team_id
      temp_player << p.position
      temp_player << p.r_cards
      temp_player << p.y_cards
      local << temp_player
    end
    visitor_players.each do |p|
      temp_player = []
      temp_player << Player.find_by(fifa_id: p.player_id)
      temp_player << p.team_id
      temp_player << p.position
      temp_player << p.r_cards
      temp_player << p.y_cards
      visitor << temp_player
    end
    @match = Match.new(local, visitor)
    p @match
  end
end