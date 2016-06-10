class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include SessionsHelper

def new_page(page)
      #URI JUGADORES
      #uri = URI("https://www.easports.com/uk/fifa/ultimate-team/api/fut/item?jsonParamObject=%7B%22page%22:#{page},%22quality%22:%22bronze,silver,gold,rare_bronze,rare_silver,rare_gold%22,%22club%22:%221%22,%22position%22:%22GK,LF,CF,RF,ST,LW,LM,CAM,CDM,CM,RM,RW,LWB,LB,CB,RB,RWB%22%7D")
      uri = URI("https://www.easports.com/fifa/ultimate-team/api/fut/item?jsonParamObject=%7B%22page%22:#{page},%22quality%22:%22bronze,silver,gold,rare_bronze,rare_silver,rare_gold%22,%22club%22:%221,2,5,7,9,10,11,13,17,18,19,95,106,109,1792,1795,1799,1806,1943,1960,58,59,62,65,66,69,70,71,72,73,74,210,217,219,294,379,1530,1809,1819,110316,39,44,45,46,47,48,52,54,55,189,192,206,1746,1837,1843,110374,110556,111657,111974,112409,21,22,23,28,31,32,34,36,38,166,169,175,485,1824,10029,100409,110502,111239,240,241,242,243,448,449,450,452,457,459,461,467,472,480,481,483,573,1853,1860,110832,1028,1032,1878,1879,1880,1881,1882,1970,101114,110144,110145,110147,110150,110152,110781,111032,111678,112679%22,%22position%22:%22GK,LF,CF,RF,ST,LW,LM,CAM,CDM,CM,RM,RW,LWB,LB,CB,RB,RWB%22%7D")
      get = Net::HTTP.get(uri)
      File.open("input.json","w+") do |f|
          f.puts get
      end
      json = File.read('input.json')
      @obj = JSON.parse(json)
  end

  def update_personality(p, traits, position)
    case position
      when "OFF"
        individual_collab = 0.9
        simple_elegant = 1.1
        zen_aggresive = 1
      when "MID"
        individual_collab = 1.1
        simple_elegant = 1
        zen_aggresive = 0.9
      when "DEF"
        individual_collab = 1.1
        simple_elegant = 0.9
        zen_aggresive = 1.1
      when "GK"
        individual_collab = 1
        simple_elegant = 1
        zen_aggresive = 1
    end
    unless traits == nil
      traits.each do |variable|
        if variable == "Selfish"
          individual_collab -= 0.3
        elsif variable == "One Club Player"
          individual_collab -= 0.2
        elsif variable == "Shooting - Long Shot Taker"
          simple_elegant += 0.1
        elsif variable == "Passing - Long Passer"
          individual_collab += 0.2
        elsif variable == "Long Throw"
          simple_elegant += 0.2 
        elsif variable == "Playmaker"
          simple_elegant += 0.1 
        elsif variable == "Chip Shot"
          zen_aggresive += 0.1  
        elsif variable == "Shooting - Finesse Shot"
          simple_elegant += 0.2 
        elsif variable == "Technical Dribbler"
          simple_elegant += 0.3 
        elsif variable == "Dribbler - Speed Dribbler"
          simple_elegant += 0.2
        elsif variable == "Crosser - Early Crosser"
          simple_elegant += 0.1
          individual_collab += 0.2  
        elsif variable == "Flair"
          simple_elegant += 0.1 
        elsif variable == "Dives Into Tackles"
          zen_aggresive += 0.2  
        elsif variable == "Tries To Beat Defensive Line"
          zen_aggresive += 0.1  
        elsif variable == "Takes Powerful Driven Free Kicks"
          zen_aggresive += 0.2  
        elsif variable == "Ultimate Professional"
          simple_elegant += 0.2 
          zen_aggresive -= 0.2
          individual_collab += 0.2
        end
      end
    end
    p.individual_collab = individual_collab
    p.zen_aggresive = zen_aggresive
    p.simple_elegant = simple_elegant
  end

  def one_page_db()
    puts "ENTRE A ONE PAGE DB"
    count = @obj["count"]
    count.times do |item|
    player = @obj["items"][item]
    p = Player.new
    
    #DATOS GENERALES

    p.name = player["name"]
    p.first_name =  player["firstName"]
    p.last_name =  player["lastName"]
    p.age = player["age"]
    p.fifa_id = player["baseId"]

    p.rating = player["rating"]

    position = player["position"]
    if (position == "LWB")||(position == "LB")||(position == "CB")||(position == "RB")||(position == "RWB")
      s_position = "DEF"
    elsif (position == "LM")||(position == "CAM")||(position == "CDF")||(position == "CDM")||(position == "CM")||(position == "RM")
      s_position = "MID"
    elsif (position == "LF")||(position == "CF")||(position == "RF")||(position == "ST") || (position == "LW") ||(position == "RW")
      s_position = "OFF"
    elsif (position == "GK")
      s_position = "GK"
    end
    p.position = s_position
    
    #LINK A SU FOTO
    p.avatar = player["headshotImgUrl"]
    
    #DETALLES DE LIGA, NACIONALIDAD Y CLUB CON IMAGEN
    p.league = player["league"]["name"]
    p.nation = player["nation"]["name"]
    p.nation_img = player["nation"]["imageUrls"]["large"]

    p.club = player["club"]["abbrName"]
    p.club_img = player["club"]["imageUrls"]["normal"]["large"]

    # html_doc = Nokogiri::HTML(open("http://sofifa.com/player/#{p.fifa_id}"))
    # value = html_doc.search(".pl > li:nth-child(10) > span").inner_text
    # value[0] = ""
    # if value[value.length-1] == "M"
    #   value[value.length-1] = ""
    #   value = value.to_f
    #   value = value * 1000000
    # elsif value[value.length-1] == "K"
    #   value[value.length-1] = ""
    #   value = value.to_f
    #   value = value * 1000
    # end
    # p.market_value = value

    # club_sofifa = html_doc.search(".pl:nth-child(2) > li:nth-child(1) > a").inner_text
    # puts "*"*50
    # p value
    # p club_sofifa

    #TRAITS ES UN ARRAY
    traits = player["traits"]
    update_personality(p, traits, s_position)

    #ATRIBUTOS GENERALES
    p.g_pacing = player["attributes"][0]["value"]
    p.g_shooting = player["attributes"][1]["value"]
    p.g_passing = player["attributes"][2]["value"]
    p.g_dribbling = player["attributes"][3]["value"]
    p.g_defense = player["attributes"][4]["value"]
    p.g_physical = player["attributes"][5]["value"]
    
    p.acceleration = player["acceleration"]
    p.aggression = player["aggression"]
    p.agility = player["agility"]
    p.balance = player["balance"]
    p.ballcontrol = player["ballcontrol"]
    p.skillMoves = player["skillMoves"]
    p.crossing = player["crossing"]
    p.curve = player["curve"]
    p.dribbling = player["dribbling"]
    p.finishing = player["finishing"]
    p.freekickaccuracy = player["freekickaccuracy"]
    p.gkdiving = player["gkdiving"]
    p.gkhandling = player["gkhandling"]
    p.gkkicking = player["gkkicking"]
    p.gkpositioning = player["gkpositioning"]
    p.gkreflexes = player["gkreflexes"]
    p.headingaccuracy = player["headingaccuracy"]
    p.interceptions = player["interceptions"]
    p.jumping = player["jumping"]
    p.longpassing = player["longpassing"]
    p.longshots = player["longshots"]
    p.marking = player["marking"]
    p.penalties = player["penalties"]
    p.positioning = player["positioning"]
    p.potential = player["potential"]
    p.reactions = player["reactions"]
    p.shortpassing = player["shortpassing"]
    p.shotpower = player["shotpower"]
    p.slidingtackle = player["slidingtackle"]
    p.sprintspeed = player["sprintspeed"]
    p.standingtackle = player["standingtackle"]
    p.stamina = player["stamina"]
    p.strength = player["strength"]
    p.vision = player["vision"]
    p.volleys = player["volleys"]

    p.save

    end

    @page += 1
  end

  def feed
    @page = 1

    @obj = new_page(@page)

    total_pages = @obj["totalPages"]

    #individual player with base id:
    #https://www.easports.com/fifa/ultimate-team/api/fut/item?jsonParam@object=%7B%22baseid%22:%22153244%22%7D

    while @page <= total_pages do
      one_page_db()
      new_page(@page)
    end
  end




  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
