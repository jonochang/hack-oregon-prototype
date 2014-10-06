class CreateAnalyticsDateEntities < ActiveRecord::Migration
  def change
    create_table :analytics_date_entities do |t|
      t.date :full_date
      t.integer :day_of_week
      t.integer :day_num_in_month
      t.integer :day_num_overall 
      t.string :day_name
      t.string :day_abbrev
      t.boolean :is_weekday
      t.integer :week_num_in_year
      t.integer :week_num_overall 
      t.date :week_begin_date
      t.integer :month
      t.integer :month_num_overall
      t.string  :month_name
      t.string  :month_abbrev
      t.integer :quarter
      t.integer :yearmonth
      t.integer :year
      t.integer :fiscal_month
      t.integer :fiscal_quarter
      t.integer :fiscal_year
      t.boolean :is_last_day_in_month
      t.date :same_day_a_year_ago

      t.timestamps
    end
  end
end
