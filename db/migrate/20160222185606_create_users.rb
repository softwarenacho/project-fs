class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :score
      t.integer :budget
      t.integer :level
      t.timestamps null: false
    end
  end
end
