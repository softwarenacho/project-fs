class Player < ActiveRecord::Base
  has_many :TeamPlayers

  # include PgSearch
  # pg_search_scope :search, 
  # :against => [:name, :first_name, :last_name, :club, :nation, :league],
  # :ignoring => :accents

  # def self.text_search(query)
  #   if query.present?
  #     search(query)
  #   else
  #     scoped
  #   end
  # end
end
