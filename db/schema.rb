# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160303151853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.integer  "local_id"
    t.integer  "visitor_id"
    t.integer  "local_goals"
    t.integer  "visitor_goals"
    t.string   "events"
    t.string   "animation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "players", force: :cascade do |t|
    t.string  "name"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "position"
    t.integer "age"
    t.integer "fifa_id"
    t.integer "rating"
    t.integer "market_value"
    t.string  "avatar"
    t.string  "league"
    t.string  "nation"
    t.string  "nation_img"
    t.string  "club"
    t.string  "club_img"
    t.float   "zen_aggresive"
    t.float   "individual_collab"
    t.float   "simple_elegant"
    t.integer "g_pacing"
    t.integer "g_shooting"
    t.integer "g_passing"
    t.integer "g_dribbling"
    t.integer "g_defense"
    t.integer "g_physical"
    t.integer "acceleration"
    t.integer "aggression"
    t.integer "agility"
    t.integer "balance"
    t.integer "ballcontrol"
    t.integer "skillMoves"
    t.integer "crossing"
    t.integer "curve"
    t.integer "dribbling"
    t.integer "finishing"
    t.integer "freekickaccuracy"
    t.integer "gkdiving"
    t.integer "gkhandling"
    t.integer "gkkicking"
    t.integer "gkpositioning"
    t.integer "gkreflexes"
    t.integer "headingaccuracy"
    t.integer "interceptions"
    t.integer "jumping"
    t.integer "longpassing"
    t.integer "longshots"
    t.integer "marking"
    t.integer "penalties"
    t.integer "positioning"
    t.integer "potential"
    t.integer "reactions"
    t.integer "shortpassing"
    t.integer "shotpower"
    t.integer "slidingtackle"
    t.integer "sprintspeed"
    t.integer "standingtackle"
    t.integer "stamina"
    t.integer "strength"
    t.integer "vision"
    t.integer "volleys"
  end

  create_table "team_players", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.string   "position"
    t.integer  "goals",          default: 0
    t.integer  "assists",        default: 0
    t.integer  "r_cards",        default: 0
    t.integer  "faults",         default: 0
    t.integer  "y_cards",        default: 0
    t.integer  "pass_success",   default: 0
    t.integer  "pass_total",     default: 0
    t.integer  "shot_success",   default: 0
    t.integer  "shot_total",     default: 0
    t.integer  "tackle_success", default: 0
    t.string   "tackle_total",   default: "0"
    t.string   "goals_conceded", default: "0"
    t.string   "goals_blocked",  default: "0"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "score"
    t.integer  "budget"
    t.integer  "level"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
