ActiveRecord::Schema.define(version: 20161130171242) do
  create_table "admins", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
  end
end