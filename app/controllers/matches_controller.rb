class MatchesController < ApplicationController

  def challenge
    players = params[:players]
    local_user = players[1]
    visitor_user = players[0]
    @local = []
    @visitor = []
    local_players = TeamPlayer.where(team_id: local_user)
    visitor_players = TeamPlayer.where(team_id: visitor_user)
    gk = local_players.find {|p| p.position == "GK"}
    local_players = local_players.sort {|a,b| a.position <=> b.position}
    local_players = local_players.unshift(gk).uniq
    gk = visitor_players.find {|p| p.position == "GK"}
    visitor_players = visitor_players.sort {|a,b| a.position <=> b.position}
    visitor_players = visitor_players.unshift(gk).uniq
    local_players.each do |p|
      temp_player = []
      temp_player << Player.find_by(fifa_id: p.player_id)
      temp_player << p.team_id
      temp_player << p.position
      temp_player << p.r_cards
      temp_player << p.y_cards
      @local << temp_player
    end
    visitor_players.each do |p|
      temp_player = []
      temp_player << Player.find_by(fifa_id: p.player_id)
      temp_player << p.team_id
      temp_player << p.position
      temp_player << p.r_cards
      temp_player << p.y_cards
      @visitor << temp_player
    end
    @local_user = User.find(local_user)
    @visitor_user = User.find(visitor_user)
    @match = Match.new(@local, @visitor)
    @match.animation.each do |k|
      k[3] = (k[3]*50)+70
    end

    gon.events = @match.events
    gon.animation = @match.animation
    gon.local = @local_user.id
  end

end