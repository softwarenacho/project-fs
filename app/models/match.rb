
class Match < ActiveRecord::Base
  belongs_to :local, class_name: 'Team', foreign_key: 'local_id'
  belongs_to :visitor, class_name: 'Team', foreign_key: 'visitor_id'

  attr_accessor :events, :animation, :local_goals, :visitor_goals

  def initialize(local, visitor)
    @time = 0
    @field = 5 #position in field
    @events = []
    @animation = []
     #hashes of match events
    @local = local #array filled with the players objects
    @visitor = visitor #array filled with the players objects
    @local_goals = 0
    @visitor_goals = 0
    @local_score = 0
    @visitor_score = 0
    @extra_time = 0
    @partial_time = 0
    @local_visitor = [@local[1], @visitor[1]]
    cp = starting_player()
    @events << ["#{@time}.#{@partial_time}","Match starts!"]
    @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
    while (@time <= 90)
      cp = iteration(cp) #ALL THE HARD WORK
    end
    #pp @events
    #pp @animation
    #update local & visitor scores
    # local_user = User.find(Team.find(@local[0][1]).user_id)
    # local_c_score = local_user.score
    # local_user.score = local_c_score + @local_score
    # local_user.save

    # visitor_user = User.find(Team.find(@visitor[0][1]).user_id)
    # visitor_c_score = visitor_user.score
    # visitor_user.score = visitor_c_score + @visitor_score
    # visitor_user.save 
  end

    # helper method to determine the local or visitor team


  #runs the match events minute by minute taking decisions and stuff FIRST REVISION
  def iteration(cp) 
    #this 2 methods fill hashes with players and probabilities
    # ot = cp[0]
    ot = local_or_visitor?(cp[1])
    dt = opposite_team(cp[1])
    if @partial_time >= 5
      @partial_time = 0
      @time += 1
    end
    
    @d_hash = prob_team(dt)
    @o_hash = prob_team(ot)
    
    #choose the defensive player to interact
    dp = select_defensive_player(dt)
    #choose the offensive and defensive actions
    #and returns their ids
    o_a = offensive_decision(cp)
    d_a = defensive_decision(dp)
    #STATS
    #returns success rates of the two actions happening
    w_a = define_winning_action(dp, cp, d_a, o_a)
    #conditional to check the new current player
    if w_a == o_a
      #consequences of offensive winning 
      cp = succession_offense(cp, o_a, dt)
    elsif w_a == d_a
      #consequences of defensive taking control 
      cp = succession_defense(cp, dp, d_a, o_a, dt)
    end
    #a minute passed 
    @partial_time += 1
    if @field > 10
      @field = 10
    elsif @field < 0
      @field = 0
    end
    #@animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals]
    cp
  end

  #2 select the player that will touch the first ball FIRST REVISION
  def starting_player()
    st = rand(0..1)
    r = rand(8..10)
    if st == 0
      @local[r]
    else
      @visitor[r]
    end
  end

  # helper method to determine the local or visitor team
  def local_or_visitor?(team_id)
    if team_id == @local[0][1]
      team = @local
    else
      team = @visitor
    end
  end

  # helper method to determine the opposite to the current player's team
  def opposite_team(team_id)
    if team_id == @local[0][1] 
      team = @visitor
    else
      team = @local
    end
  end

  #3 returns a probability hash for the indicated team FIRST REVISION
  def prob_team(cp)
    prob_hash = {}
     #creates and array with players to be used
    #and their percentage of probability
    #to be selected in later actions
    team = cp
    if @field > 10
      @field = 10
    elsif @field < 0
      @field = 0
    end
    def_count = team.count { |element| element[2].match("DEF") }
    mid_count = team.count { |element| element[2].match("MID") }
    off_count = team.count { |element| element[2].match("OFF") }
    if team == @local
      case @field 
        when 10
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 70/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 20/mid_count.to_f
            elsif member[2] == "DEF"
              prob_hash[member] = 10/def_count.to_f
            end
          end
       when 9, 8
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 60/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 30/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 10/def_count.to_f
          end
        end
      when 7, 6
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 50/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 40/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 10/def_count.to_f
          end
        end
      when 5 
        if @events.last[1].include?("goal")
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 70/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 20/mid_count.to_f
            elsif member[2] == "DEF"  
              prob_hash[member] = 10/def_count.to_f
            end
          end
        else
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 25/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 50/mid_count.to_f
            elsif member[2] == "DEF"  
              prob_hash[member] = 25/def_count.to_f
            end
          end
        end
      when 4, 3
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 40/mid_count.to_f
          elsif member[2] == "DEF"  
            prob_hash[member] = 50/def_count.to_f
          end
        end
      when 2, 1
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 30/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 60/def_count.to_f
          end
        end
      when 0
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 20/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 70/def_count.to_f
          end
        end
      end

    else
      case @field 
        when 0
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 70/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 20/mid_count.to_f
            elsif member[2] == "DEF"
              prob_hash[member] = 10/def_count.to_f
            end
          end
       when 1, 2
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 60/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 30/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 10/def_count.to_f
          end
        end
      when 3, 4
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 50/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 40/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 10/def_count.to_f
          end
        end
      when 5 
        if @events.last[1].include?("goal")
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 70/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 20/mid_count.to_f
            elsif member[2] == "DEF"  
              prob_hash[member] = 10/def_count.to_f
            end
          end
        else
          team.each do |member|
            if member[2] == "OFF"
              prob_hash[member] = 25/off_count.to_f
            elsif member[2] == "MID"
              prob_hash[member] = 50/mid_count.to_f
            elsif member[2] == "DEF"  
              prob_hash[member] = 25/def_count.to_f
            end
          end
        end
      when 6, 7
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 40/mid_count.to_f
          elsif member[2] == "DEF"  
            prob_hash[member] = 50/def_count.to_f
          end
        end
      when 8, 9
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 30/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 60/def_count.to_f
          end
        end
      when 10
        team.each do |member|
          if member[2] == "OFF"
            prob_hash[member] = 10/off_count.to_f
          elsif member[2] == "MID"
            prob_hash[member] = 20/mid_count.to_f
          elsif member[2] == "DEF"
            prob_hash[member] = 70/def_count.to_f
          end
        end
      end
    end
    team.each do |p| 
      if p[3] >= 1
      prob_hash[p] = 0
      end
    end  
    prob_hash
  end

  #7 choose a defensive player based on probability and randomness FIRST REVISION
  def select_defensive_player(dt)
    #an action will be analyzed for the defensive player
    @d_hash = prob_team(dt)
    @d_hash.clone.each { |k,v| @d_hash[k] = v.to_f*rand(0.75..1.15)}
    @d_hash.clone.each do |k, v| 
      if k[3] >= 1 
        @d_hash[k] = 0
      else
        @d_hash[k] = v
      end
    end
    dp = @d_hash.clone.max_by {|k,v| v}
    dp[0]
  end

  #helper method to reverse values
  def reverse_v(number)
    if number <= 1.0
      remainder = 1.0 - number
      new_number = 1.0 + remainder
    else 
      remainder = number - 1.0
      new_number = 1.0 - remainder
    end
  end

  # helper method to reverse field positions
  def reverse_f(field)
    if field <= 5
       remainder = 5 - field
       new_number = 5 + remainder
     else 
      remainder = field - 5
      new_number = 5 - remainder
     end
  end

  #5 returns a string with the defensive action to execute
  def defensive_decision(dp)
    hash = {"slide_steal" => 0,"tackle_steal" => 0,"contain" => 0,"pull" => 0}
      field = @field
      if dp[1] == @local[0][1] 
        field = reverse_f(field)
      end
      if field == 0
        field_prob = 2.0
      else
        field_prob = field/5.0
      end
      slide_steal_prob = dp[0].simple_elegant*rand(0.9..1.1)
      hash["slide_steal"] = slide_steal_prob
      tackle_steal_prob = dp[0].simple_elegant*dp[0].zen_aggresive*rand(0.9..1.1)*reverse_v(field_prob)
      hash["tackle_steal"] = tackle_steal_prob
      contain_prob = reverse_v(dp[0].simple_elegant)*dp[0].individual_collab*reverse_v(dp[0].zen_aggresive)*rand(0.9..1.1)*field_prob
      hash["contain"] = contain_prob*0.2
      pull_prob = dp[0].zen_aggresive*rand(0.9..1.1)*reverse_v(field_prob)
      hash["pull"] = pull_prob
      d_a = hash.clone.max_by {|k,v| v}
      d_a= d_a[0]
  end

  #6 returns a string with the offensive action to execute
  def offensive_decision(cp)
    hash = {"normal_shot" => 0,"chip_shot" => 0,"finesse_shot" => 0,"short_pass" => 0, "lob_pass" => 0,"pass_through" => 0,"lob_through" => 0,"bouncy_lob" => 0, "lob_cross" => 0,"ground_cross" => 0,"skill_move" => 0,"slow_dribble" => 0, "fast_dribble" => 0,"fake_move" => 0,"sprint" => 0,"normal_pace" => 0}
      field = @field
    if cp[1] != @local[0][1]
      field = reverse_f(field)
    end
    if field == 0
      field_prob = 0.0
    else
      field_prob = field / 5.0
    end
    short_pass_prob = reverse_v(cp[0].simple_elegant)*cp[0].individual_collab*rand(0.85..1)*field_prob
    hash["short_pass"] = short_pass_prob
    ground_cross_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)
    hash["ground_cross"] = ground_cross_prob
    skill_move_prob = cp[0].simple_elegant*rand(0.85..1.15)
    hash["skill_move"] = skill_move_prob
    slow_dribble_prob = reverse_v(cp[0].simple_elegant)*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*0.5
    hash["slow_dribble"] = slow_dribble_prob
    fast_dribble_prob = cp[0].simple_elegant*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)
    hash["fast_dribble"] = fast_dribble_prob
    fake_move_prob = cp[0].simple_elegant*rand(0.85..1.15)*field_prob
    hash["fake_move"] = fake_move_prob
    sprint_prob = reverse_v(cp[0].individual_collab)*rand(0.85..1.15)
    hash["sprint"] = sprint_prob
    normal_pace_prob = reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*reverse_v(field_prob)*0.5
    hash["normal_pace"] = normal_pace_prob
        

    if (field_prob >= 1.2) && (field_prob <= 1.6)
      field_prob += 0.3
    end
   

    lob_through_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_through"] = lob_through_prob
    bouncy_lob_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["bouncy_lob"] = bouncy_lob_prob
    lob_cross_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_cross"] = lob_cross_prob
    lob_pass_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_pass"] = lob_pass_prob
    pass_through_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["pass_through"] = pass_through_prob

    if (field_prob == 1) 
      field_prob -= 0.2
    end

    if (field_prob < 1) 
      field_prob = 0
    end

    normal_shot_prob = reverse_v(cp[0].simple_elegant)*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["normal_shot"] = normal_shot_prob
    chip_shot_prob = cp[0].zen_aggresive*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["chip_shot"] = chip_shot_prob
    finesse_shot_prob = cp[0].simple_elegant*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["finesse_shot"] = finesse_shot_prob

    o_a = hash.clone.max_by {|k,v| v}
    o_a = o_a[0]
  end
  
  def factor_calc(player)
    if player[1] == @local[0][1]
      field = @field * 10.0
      field = field + player[0].longshots
      field = field/2.0
    else
      field = 10.0 - @field
      field = field * 10.0
      field = field + player[0].longshots
      field = field/2.0
  end
    field
  end
  
  


  # returns a numbers array with the variables ordered by ascending importance
  def array_maker(player,action)
    array = []
    distance_factor = factor_calc(player)
    case action
      when "normal_shot"
        array.push(player[0].headingaccuracy,distance_factor,player[0].finishing,player[0].positioning,player[0].g_shooting)
      when "chip_shot"
        array.push(player[0].positioning,distance_factor,player[0].finishing,player[0].shotpower,player[0].g_shooting)
      when "finesse_shot"
        array.push(distance_factor,player[0].positioning,player[0].finishing,player[0].headingaccuracy,player[0].g_shooting)
      when "normal_pace"
        array.push(player[0].g_physical,player[0].reactions,player[0].g_pacing)
      when "sprint"
       array.push(player[0].stamina,player[0].acceleration,player[0].reactions,player[0].g_physical,player[0].sprintspeed,player[0].g_pacing)
      when "lob_pass"
        array.push(player[0].positioning,player[0].vision,player[0].finishing,player[0].longpassing,player[0].g_passing)
      when "short_pass"
        array.push(player[0].reactions,player[0].shortpassing,player[0].g_passing)
      when "pass_through"
         array.push(player[0].vision,player[0].shortpassing,player[0].g_passing)
      when "lob_cross"
        array.push(player[0].longpassing,player[0].crossing,player[0].g_passing)
      when "lob_through"
        array.push(player[0].vision,player[0].longpassing,player[0].g_passing)
      when "ground_cross"
         array.push(player[0].shortpassing,player[0].crossing,player[0].g_passing)
      when "bouncy_lob"
        array.push(player[0].finishing,player[0].positioning,player[0].vision,player[0].longpassing,player[0].g_passing)
      when "skill_move"
        array.push(player[0].reactions,player[0].g_dribbling,player[0].ballcontrol,player[0].skillMoves,player[0].g_dribbling)
      when "slow_dribble"
        array.push(player[0].reactions,player[0].ballcontrol,player[0].g_dribbling,player[0].g_dribbling)
      when "fast_dribble"
        array.push(player[0].stamina,player[0].g_physical,player[0].sprintspeed,player[0].g_pacing,player[0].reactions,player[0].ballcontrol,player[0].g_dribbling,player[0].g_dribbling)
      when "fake_move"
        array.push(player[0].g_dribbling,player[0].ballcontrol,player[0].reactions,player[0].g_dribbling)
      when "tackle_steal"
        array.push(player[0].agility,player[0].aggression,player[0].acceleration,player[0].standingtackle,player[0].g_defense) 
      when "slide_steal"
        array.push(player[0].agility,player[0].acceleration,player[0].slidingtackle,player[0].g_defense) 
      when "block"
        array.push(player[0].stamina,player[0].agility,player[0].acceleration,player[0].interceptions,player[0].aggression,player[0].g_physical,player[0].g_defense)     
      when "pull"
        array.push(player[0].stamina,player[0].agility,player[0].acceleration,player[0].interceptions,player[0].aggression,player[0].g_physical,player[0].g_defense)
      when "contain"
        array.push(player[0].stamina,player[0].agility,player[0].interceptions,player[0].acceleration,player[0].g_physical,player[0].g_defense)   
    end
  end

  #multiplies stats times importance to return a success rate
  def success_rate(hash)
    equation_array = []
    hash.each do |k,v|
      eq = (k * v)
      equation_array << eq
    end
    total = equation_array.inject(:+)
    s_r = (total/100.00)*rand(0.65..1.35)
  end

  #attributes importance to each stat
  def success_hash(array)
    length = array.length
    hash = {}
    half = (length / 2)  
    total = array.inject(:+)
    average_probability = 100 / length
    working_variable = average_probability / (length - 1)
    if length % 2 == 1
      array.each do |variable|
        half -= 1
        number = average_probability - (working_variable * half)
        hash[number] = variable
      end  
    else
      array.each do |variable|
        if variable == array[half + 1]
          number = average_probability - (working_variable * half)
          half -= 2
          hash[number] = variable
        else
          number = average_probability - (working_variable*half)
          half = half -= 1
          hash[number] = variable
        end
      end  
    end
    success_rate(hash)
  end

  #8 tie breaker with random FIRST REVISION
  def random_winner(o_a, d_a)
    r = rand(0..1)
    r == 0 ? o_a : d_a
  end  

  # determine the highest success rate action FIRST REVISION
  def define_winning_action(dp, cp, d_a, o_a)
    v_array_d = array_maker(dp, d_a)
    v_array_o = array_maker(cp, o_a)
    @o_sr = success_hash(v_array_o)*rand(0.60..1.30)
    @d_sr = success_hash(v_array_d)*rand(1.8..2.0)
    if dp[2] == "OFF"
      @d_sr *= 0.3
    elsif dp[2] == "MED"
      @d_sr *= 0.7
    end
    if @o_sr > @d_sr
      o_a
    elsif @d_sr > @o_sr
      d_a
    else
      random_winner(o_a,d_a)
    end
  end

  #9 sums score to the corresponding team accordingly to the value
  def add_score(team, value)
    if team == @local[0][1] 
      @local_score += value
    else
      @visitor_score += value
    end
  end

  # Add a goal to the corresponding team
  def add_goal(team)
    if team == @local[0][1] 
      @local_goals += 1
    else
      @visitor_goals += 1
    end
  end

  #changes the action name to a readable format
  def format(string)
    formatted = string.gsub("_", " ")
  end

  #moves the field position according to the move executed
  def field_change(team,value)
    if team == @local[0][1] 
      @field += value
    else
      @field -= value
    end
  end

  #determine if the shot will be a goal
  def gk(cp, o_a)
    team = opposite_team(cp[1])
    gp =  team[0]
    case o_a
      when "finesse_shot"
        gk_stats = [gp[0].gkdiving, gp[0].gkreflexes, gp[0].gkhandling, gp[0].gkpositioning]
        gk_sr = success_hash(gk_stats)*2.2
      when "normal_shot"
        gk_stats = [gp[0].gkpositioning, gp[0].gkdiving, gp[0].gkhandling, gp[0].gkreflexes]
        gk_sr = success_hash(gk_stats)*2.2
      when "chip_shot"
        gk_stats = [gp[0].gkhandling, gp[0].gkpositioning, gp[0].gkdiving, gp[0].gkreflexes]
        gk_sr = success_hash(gk_stats)*2.2
      when "penalty_kick"
        gk_stats = [gp[0].gkpositioning, gp[0].gkdiving, gp[0].gkhandling, gp[0].gkreflexes]
        gk_sr = success_hash(gk_stats)*2.2
    end
    if gk_sr > @o_sr
      false
    elsif gk_sr < @o_sr
      true
    else
      r = rand(0..1)
      r == 0 ? true : false
    end
  end

  #determine the action following a blocked shot
  def gk_succession(cp,dt)
    if cp[1] == @local[0][1] 
      @field = 10
    else
      @field = 0
    end
    op = cp
    team = opposite_team(cp[1])
    gp =  team[0]
    cp = select_defensive_player(team)
    @animation << ["#{@time}.#{@partial_time}",op[0].name,op[0].avatar, @field, @local_goals,@visitor_goals,op[1]]
    @events << ["#{@time}.#{@partial_time}", "#{op[0].name} tried to score but #{gp[0].name}  blocked the shot!"]
    #passes the ball to #{cp[0].name}!"]
    @partial_time += 1
    @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
    @events << ["#{@time}.#{@partial_time}", " #{gp[0].name} passes the ball to #{cp[0].name}!"]
    cp
  end

  #define if a shot will end in goal or not
  def shot_action(cp, o_a, dt)
    add_score(cp[1], 2)
    if out_of_field?("o") == false
       if gk(cp, o_a) == true
         @field = 5
         @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
         @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} uses #{format(o_a)} and scores a goal!"]
         add_score(cp[1],5)
         ot_id = opposite_team(cp[1])
         add_score(ot_id,-1)
         add_goal(cp[1])
         cp = select_defensive_player(dt)
       else
         cp = gk_succession(cp,dt)
       end
    else
      @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
      @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} attempts #{format(o_a)} but misses"]
      cp = out_of_field(cp,"o",dt)
    end
  end

  #returns the current player after the ball goes out of field
  def out_of_field(player,side,dt)
    if side == "o"
      cp = select_defensive_player(dt)
    else
      ot = opposite_team(player[1])
      cp = select_offensive_player(ot,player)
    end
  end

  # determine if the ball goes out of field
  def out_of_field?(side)
    if side == "o"
      check = @o_sr*rand(0.80..1.2)
      if check < 60
        true
      else
        false
      end
    else 
      check = @d_sr*rand(0.80..1.2)
      if check < 60
        true
      else
        false
      end
    end
  end

  #determine the player that will receive the ball in an offensive action
  def select_offensive_player(ot,cp)
    @o_hash = prob_team(ot)
      @o_hash.clone.each do |k,v| 
       if k == cp
         @o_hash[k] = 0
       else
         @o_hash[k] = @o_hash[k] = v.to_f*rand(0.75..1.15)
       end
     end

    @o_hash.clone.each do |k, v| 
      if k[3] >= 1 
        @o_hash[k] = 0
      else
        @o_hash[k] = v
      end
    end
    cp = @o_hash.clone.max_by {|k,v| v}
    cp = cp[0]
  end

  #decides what will happen after action comparison with complex methods
  def succession_offense(cp, o_a, dt)
    ot = local_or_visitor?(cp[1])
    case o_a
      when "normal_pace"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} moves at #{format(o_a)}"]
        field_change(cp[1],1)
        cp
      when "sprint"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} moves at #{format(o_a)} speed"]
        field_change(cp[1],2)
        cp
      when "skill_move"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} performs a #{format(o_a)} successfully"]
        field_change(cp[1],1)
        cp
      when "slow_dribble"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} performs a #{format(o_a)} successfully"]
        field_change(cp[1],1)
        cp
      when "fast_dribble"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} performs a #{format(o_a)} successfully"]
        field_change(cp[1],2)
        cp
      when "fake_move"
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} performs a #{format(o_a)} successfully"]
        field_change(cp[1],1)
        cp
      when "lob_through"
        add_score(cp[1], 2)
        cpp = cp
        field_change(cp[1],2)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "bouncy_lob"
        add_score(cp[1], 2)
        cpp = cp
        field_change(cp[1],1)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "lob_cross"
        add_score(cp[1], 2)
        cpp = cp
        field_change(cp[1],1)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "ground_cross"
        add_score(cp[1], 2)
        cpp = cp
        field_change(cp[1],1)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "lob_pass"
        add_score(cp[1], 1)
        cpp = cp
        field_change(cp[1],1)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "pass_through"
        add_score(cp[1], 1)
        cpp = cp
        field_change(cp[1],2)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "short_pass"
        add_score(cp[1], 1)
        cpp = cp
        field_change(cp[1],1)
        cp = select_offensive_player(ot,cp)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cpp[0].name} performs a #{format(o_a)} to #{cp[0].name}"]
        cp
      when "normal_shot"
        cp = shot_action(cp, o_a, dt)
      when "finesse_shot"
        cp = shot_action(cp, o_a, dt)
      when "chip_shot"
        cp = shot_action(cp, o_a, dt)
    end
  end


  def fault?(cp, dp)
    dp_za = dp[0].zen_aggresive * 100
    s_r = success_hash([dp[0].strength, dp[0].aggression, dp_za])
    s_r = s_r * rand(0.75..1.10)
  end

  def free_kick_action(cp)
    hash = {"normal_shot" => 0,"chip_shot" => 0,"finesse_shot" => 0,"short_pass" => 0, "lob_pass" => 0,"pass_through" => 0,"lob_through" => 0,"bouncy_lob" => 0, "lob_cross" => 0,"ground_cross" => 0}
    field = @field
    if cp[1] != @local[0][1] 
      field = reverse_f(field)
    end
    if field == 0
      field_prob = 0
    else
      field_prob = field / 5
    end
    short_pass_prob = reverse_v(cp[0].simple_elegant)*cp[0].individual_collab*rand(0.85..1)*field_prob
    hash["short_pass"] = short_pass_prob
    ground_cross_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)
    hash["ground_cross"] = ground_cross_prob
        
     if (field_prob == 1) 
       field_prob -= 0.2
     end

    normal_shot_prob = reverse_v(cp[0].simple_elegant)*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["normal_shot"] = normal_shot_prob*1.5
    chip_shot_prob = cp[0].zen_aggresive*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["chip_shot"] = chip_shot_prob
    finesse_shot_prob = normal_shot_prob*1.5
    chip_shot_prob = cp[0].simple_elegant*reverse_v(cp[0].individual_collab)*rand(0.85..1.15)*field_prob
    hash["finesse_shot"] = finesse_shot_prob*1.5

     if (field_prob >= 1.2) && (field_prob <= 1.6)
       field_prob += 0.8
     end

    lob_through_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_through"] = lob_through_prob
    bouncy_lob_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["bouncy_lob"] = bouncy_lob_prob
    lob_cross_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_cross"] = lob_cross_prob
    lob_pass_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["lob_pass"] = lob_pass_prob
    pass_through_prob = cp[0].simple_elegant*cp[0].individual_collab*rand(0.85..1.15)*field_prob
    hash["pass_through"] = pass_through_prob
    o_a = hash.select {|k,v| v == hash.values.max }
    o_a = o_a.keys[0]
  end

  def free_kick(cp,dt)
    ot = local_or_visitor?(cp[1])
    cp = select_offensive_player(ot,cp)
    o_a = free_kick_action(cp)
    @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
    @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} will execute the free kick"]
    @partial_time += 1
    @extra_time += 1
    cp = succession_offense(cp, o_a, dt)
  end

  def penalty(cp,dt)
    ot = local_or_visitor?(cp[1])
    cp = select_offensive_player(ot,cp)
    o_a = "penalty_kick"
    @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
    @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} will execute the penalty"]
    @partial_time += 1
    @extra_time += 1
    cp = shot_action(cp, o_a, dt)
  end

  def fault(dp, d_a, cp, dt)
    #@events["#{@time}.#{@partial_time}"] = "#{dp[0].name} commited a foul"
    #@partial_time += 1
    #@animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals]
    if dp[1] == @local[0][1]  
      if @field == 0
        penalty(cp, dt)
      else
        free_kick(cp, dt)
      end
    else
      if @field == 10
        penalty(cp, dt)
      else
        free_kick(cp, dt)
      end
    end
  end

  #determine if the defensive player who commited a foul will receive a card
  def card_worthy(dp, d_a, cp, dt)
    r = rand(0..7)
    if r == 7
      dp[3]  = 1
      @animation<< ["#{@time}.#{@partial_time}",dp[0].name,dp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
      @events << ["#{@time}.#{@partial_time}", "#{dp[0].name} tried #{format(d_a)} and commited a foul, received a red card"]
      @partial_time += 1
      @extra_time += 1
    else
      if dp[4] >= 1
        dp[4] += 1
        dp[3]  += 1
        @animation<< ["#{@time}.#{@partial_time}",dp[0].name,dp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{dp[0].name} tried #{format(d_a)} and commited a foul, received second yellow card"]
        @partial_time += 1
        @extra_time += 1
      else
        dp[4] += 1
        @animation<< ["#{@time}.#{@partial_time}",dp[0].name,dp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{dp[0].name} tried #{format(d_a)} and commited a foul, received a yellow card"]
        @partial_time += 1
        @extra_time += 1
      end
    end
    fault(dp, d_a, cp, dt)
  end

  #check if a defensive move is fault and make succession action
  def defensive_steal(dp, d_a, cp, o_a, dt)
    sr = fault?(cp, dp)
    if sr > 200
      cp = card_worthy(dp, d_a, cp, dt)
    elsif sr > 180
      @animation<< ["#{@time}.#{@partial_time}",dp[0].name,dp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
      @events << ["#{@time}.#{@partial_time}", "#{dp[0].name} tried #{format(d_a)} and commited a foul"]
      @partial_time += 1
      cp = fault(dp, d_a, cp, dt)
    else
      add_score(dp[1], 1)
      @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,dp[1]]
      @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} attempted #{format(o_a)} but #{dp[0].name} performed #{format(d_a)}"]
      @partial_time += 1
      cp = dp
    end
  end

  #10 determine what happen after a defensive action
  def succession_defense(cp, dp, d_a, o_a, dt)
    ot = local_or_visitor?(cp[1])
    case d_a
      when "contain"
        add_score(cp[1], 1)
        @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
        @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} attempted #{format(o_a)} but #{dp[0].name} performed #{format(d_a)}"]
        cp
      when "pull"
        cp = defensive_steal(dp, d_a, cp, o_a, dt)
      when "block"
        if out_of_field?("d") == true
          @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,dp[1]]
          @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} attempted #{format(o_a)} but #{dp[0].name} performed #{format(d_a)} and the ball is now out of the field"]
          cp = out_of_field(dp, "d", dt)
        else
          add_score(cp.team, 1)
          @animation<< ["#{@time}.#{@partial_time}",cp[0].name,cp[0].avatar, @field,@local_goals,@visitor_goals,cp[1]]
          @events << ["#{@time}.#{@partial_time}", "#{cp[0].name} attempted #{format(o_a)} but #{dp[0].name} performed #{format(d_a)}"]
          r = rand(0..1)
          r == 0 ? cp = select_offensive_player(ot,cp) : cp = select_defensive_player(dt)
        end      
      when "slide_steal"
        cp = defensive_steal(dp, d_a, cp, o_a, dt)
      when "tackle_steal"
        cp = defensive_steal(dp, d_a, cp, o_a, dt)
    end
  end

end

#Por fin! 1000 líneas