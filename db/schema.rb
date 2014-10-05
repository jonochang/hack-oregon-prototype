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

ActiveRecord::Schema.define(version: 20141004074114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaign_finance_transactions", force: true do |t|
    t.integer  "oregon_state_file_id"
    t.integer  "source_id"
    t.string   "original_id"
    t.date     "transaction_date"
    t.string   "transaction_status"
    t.string   "filer"
    t.string   "contributor_payee"
    t.string   "sub_type"
    t.decimal  "amount"
    t.decimal  "aggregate_amount"
    t.integer  "contributor_payee_committee_id"
    t.integer  "filer_id"
    t.string   "attest_by_name"
    t.date     "attest_date"
    t.string   "review_by_name"
    t.date     "review_date"
    t.date     "due_date"
    t.date     "occptn_ltr_date"
    t.text     "payment_schedule_txt"
    t.string   "purpose_description"
    t.decimal  "interest_rate"
    t.string   "check_number"
    t.string   "filed_by_name"
    t.string   "tran_stsfd_indicator"
    t.date     "filed_date"
    t.string   "addr_book_agent_name"
    t.string   "book_type"
    t.string   "title"
    t.string   "occupation"
    t.string   "employer_name"
    t.string   "employer_city"
    t.string   "employer_state"
    t.string   "employer_indicator"
    t.string   "self_employed_indicator"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "zip_plus_four"
    t.string   "county"
    t.string   "purpose_codes"
    t.date     "exp_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_finance_transactions", ["filed_date"], name: "index_campaign_finance_transactions_on_filed_date", using: :btree
  add_index "campaign_finance_transactions", ["oregon_state_file_id"], name: "index_campaign_finance_transactions_on_oregon_state_file_id", using: :btree
  add_index "campaign_finance_transactions", ["source_id"], name: "index_campaign_finance_transactions_on_source_id", using: :btree
  add_index "campaign_finance_transactions", ["transaction_date"], name: "index_campaign_finance_transactions_on_transaction_date", using: :btree

  create_table "oregon_state_files", force: true do |t|
    t.integer  "data_type"
    t.json     "query"
    t.string   "source_xls_file_file_name"
    t.string   "source_xls_file_content_type"
    t.integer  "source_xls_file_file_size"
    t.datetime "source_xls_file_updated_at"
    t.datetime "downloaded_at"
    t.string   "converted_csv_file_file_name"
    t.string   "converted_csv_file_content_type"
    t.integer  "converted_csv_file_file_size"
    t.datetime "converted_csv_file_updated_at"
    t.datetime "converted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
