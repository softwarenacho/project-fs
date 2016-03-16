class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      team = TeamPlayer.where(team_id: current_user.id)
      unless team.empty?
        gk = team.find {|p| p.position == "GK"}
        if gk == nil
          team = team.sort {|a,b| a.position <=> b.position}
        else
          team = team.sort {|a,b| a.position <=> b.position}
          team = team.unshift(gk).uniq
        end
        @myplayers = []
        team.each do |p|
          id = p.player_id
          @myplayers << Player.find_by(fifa_id: id)
        end
      end
      @players = Player.paginate(:page => params[:page], :per_page => 25).order(rating: :desc)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
