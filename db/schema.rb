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

ActiveRecord::Schema.define(version: 20171108230907) do

  create_table "answers", force: :cascade do |t|
    t.integer "student_id"
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chair_id"
    t.integer "reply_option_id"
    t.index ["chair_id"], name: "index_answers_on_chair_id"
    t.index ["reply_option_id"], name: "index_answers_on_reply_option_id"
    t.index ["student_id"], name: "index_answers_on_student_id"
    t.index ["survey_id"], name: "index_answers_on_survey_id"
  end

  create_table "approved_subjects", force: :cascade do |t|
    t.integer "student_id"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_approved_subjects_on_student_id"
    t.index ["subject_id"], name: "index_approved_subjects_on_subject_id"
  end

  create_table "chairs", force: :cascade do |t|
    t.integer "subject_in_quarter_id"
    t.integer "quota", default: 0
    t.integer "number"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_in_quarter_id"], name: "index_chairs_on_subject_in_quarter_id"
  end

  create_table "reply_options", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reply_options_subjects", id: false, force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "reply_option_id", null: false
    t.index ["reply_option_id", "subject_id"], name: "index_reply_options_subjects_on_reply_option_id_and_subject_id"
    t.index ["subject_id", "reply_option_id"], name: "index_reply_options_subjects_on_subject_id_and_reply_option_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "identity_document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_in_quarters", force: :cascade do |t|
    t.integer "subject_id"
    t.integer "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_subject_in_quarters_on_subject_id"
    t.index ["survey_id"], name: "index_subject_in_quarters_on_survey_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "quarter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
