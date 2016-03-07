class TeamPlayer < ActiveRecord::Base
   belongs_to :Team
   belongs_to :Player
end
