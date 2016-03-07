class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @current_team = TeamPlayer.where(team_id: 3)
      @static_pages = Player.paginate(page: params[:page]).order(market_value: :desc)
    end
  end

  def team_player
    puts "FUNCIONA"
    players = params[:players]
    team = params[:team]
    players.each do |p|
      p = Player.find_by(fifa_id: p.to_i)
      TeamPlayer.create(player_id: p.fifa_id, team_id: team, position: p.position)
    end
    redirect_to root_url
  end

  def help
  end

  def about
  end

  def contact
  end

end
