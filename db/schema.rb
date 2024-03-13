# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_312_112_436) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "integrity_logs", force: :cascade do |t|
    t.string "idfa", null: false
    t.integer "ban_status", default: 0, null: false
    t.string "ip", null: false
    t.string "rooted_device"
    t.string "country"
    t.string "proxy"
    t.string "vpn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ban_status"], name: "index_integrity_logs_on_ban_status"
    t.index ["idfa"], name: "index_integrity_logs_on_idfa"
    t.index ["ip"], name: "index_integrity_logs_on_ip"
  end

  create_table "users", force: :cascade do |t|
    t.string "idfa", null: false
    t.integer "ban_status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ban_status"], name: "index_users_on_ban_status"
    t.index ["idfa"], name: "index_users_on_idfa", unique: true
  end
end
