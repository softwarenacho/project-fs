class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |m|
      m.integer   "local_id"
      m.integer   "visitor_id"
      m.integer   "local_goals" 
      m.integer   "visitor_goals"
      m.string    "events"
      m.string    "animation"
      m.timestamps null:false
    end
  end
end
