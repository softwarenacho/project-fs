class PlayersController < ApplicationController

  def add
    id = params[:id]
    @player = Player.find_by(fifa_id: id)
    @user = current_user
    team = TeamPlayer.where(team_id: @user.id)
    teamplayer = TeamPlayer.new(player_id: @player.fifa_id, team_id: @user.id, position: @player.position)
    @user.budget -= @player.market_value
    value = (@user.budget/1000000.0*100).round/100.0
    check = team.select {|p| p.player_id == id.to_i }
    if (@user.budget < 0)
      @saved = "budget"
    elsif !check.empty?
      @saved = "exist"
    elsif team.length >= 11
      @saved = "11"
    else
      if @player.position == "GK"
        gkcheck = team.select {|p| p.position == "GK" }
        if !gkcheck.empty?
          @saved = "GK"
        else
          teamplayer.save
          @saved = "saved"
          @user.save 
        end 
      else 
        teamplayer.save
        @saved = "saved"
        @user.save 
      end
    end
    if value < 1
      value = value * 1000
      @string_value = "€ #{value} K"
    else
      @string_value = "€ #{value} M"
    end
  end

  def delete
    @id = params[:id]
    @user = current_user
    team = TeamPlayer.where(team_id: @user.id)
    p team
    teamplayer = team.select {|p| p.player_id == @id.to_i } 
    puts "teams"
    p teamplayer
    play = teamplayer.first
    p play
    play.destroy
    @user.budget += Player.find_by(fifa_id: @id).market_value
    value = (@user.budget/1000000.0*100).round/100.0
    if value < 1
      value = value * 1000
      @string_value = "€ #{value} K"
    else
      @string_value = "€ #{value} M"
    end
    @user.save
  end

end
