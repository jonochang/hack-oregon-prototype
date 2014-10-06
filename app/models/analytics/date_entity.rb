class Analytics::DateEntity < ActiveRecord::Base
  scope :group_by_full_date, -> { group(:full_date).select(:full_date) }
  scope :within_date_range, -> (from_date, to_date) { where(full_date: from_date..to_date) }

  def self.build_for date, start_date
    day_num_overall = (date - start_date).to_i + 1
    week_num_overall = ((day_num_overall + start_date.wday - 1)/ 7.0).ceil
    month_num_overall = ((date.year * 12 + date.month) - (start_date.year * 12 + start_date.month)) + 1
    financial_date_proxy = (date + 6.months)

    self.new full_date: date,
               day_of_week: date.wday,
               day_num_in_month: date.day,
               day_num_overall: day_num_overall,
               day_name: Date::DAYNAMES[date.wday],
               day_abbrev: Date::ABBR_DAYNAMES[date.wday],
               is_weekday: (date.wday >= 1 && date.wday <= 5),
               week_num_in_year: date.cweek,
               week_num_overall: week_num_overall,
               week_begin_date: date.beginning_of_week,
               month: date.month,
               month_num_overall: month_num_overall,
               month_name: Date::MONTHNAMES[date.month],
               month_abbrev: Date::ABBR_MONTHNAMES[date.month],
               quarter: (date.month / 3.0).ceil,
               yearmonth: "#{date.year}#{"%02d" % date.month}".to_i,
               year: date.year,
               fiscal_month: financial_date_proxy.month,
               fiscal_quarter: (financial_date_proxy.month / 3.0).ceil,
               fiscal_year: financial_date_proxy.year,
               is_last_day_in_month: (date == date.end_of_month),
               same_day_a_year_ago: date - 1.year,
               created_at: DateTime.now,
               updated_at: DateTime.now

  end

  def self.seed period
    start_date = Date.new(1990,1,1)
    d = start_date
    end_date = start_date + period

    Rails.logger.info "Generating date entities from #{start_date} till #{end_date}"
    puts "Generating date entities from #{start_date} till #{end_date}"
    
    date_entities = []
    begin
      date_entities << build_for(d, start_date)
      d += 1.day
    end while d < end_date

    cols = self.columns.map(&:name).select{|e| e != "id" }

    Rails.logger.info "Generating sql date entities from #{start_date} till #{end_date}"
    puts "Generating sql date entities from #{start_date} till #{end_date}"

    values_sql = date_entities.map{|e| "(#{e.attributes.reduce({}){|hash, (k,v)| hash.merge(k => self.connection.quote(v, self.columns_hash[k])) }
                              .values_at(*cols).join(',')})" }
                              .join(",")

    sql = "INSERT INTO analytics_date_entities(#{cols.join(",")}) VALUES #{values_sql}"
    self.connection.execute sql
  end

  def self.find_or_create_by_full_date full_date
    date_entity = self.where(full_date: full_date).first

    if date_entity.blank?
      raise "please run rake db:seed_fu to generate dates" if Analytics::DateEntity.count == 0
      first_date = Analytics::DateEntity.order(:full_date).first
      date_entity = self.build_for(full_date, first_date.full_date)
      date_entity.save!
    end

    return date_entity
  end
end
