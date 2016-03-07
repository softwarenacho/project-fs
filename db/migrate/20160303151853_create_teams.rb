class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |m|
      m.string   "name"
      m.string   "logo"
      m.integer   "user_id"
      m.timestamps null:false
    end
  end
end
