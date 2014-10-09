class Candidate < ActiveRecord::Base
  has_many :candidate_filings
  has_many :committees
  has_many :campaign_finance_transactions, through: :committees

  #validates :candidate_source_id, presence: true, numericality: true

  def stats_by_date from_date, to_date
    events_by_date = campaign_finance_transactions.group(:sub_type)
                          .select(:sub_type)
                          .group(:transaction_date)
                          .select(:transaction_date)
                          .sum(:amount)

    types = campaign_finance_transactions.select(:sub_type).uniq.pluck(:sub_type)

    (from_date..to_date).map{ |date|
      {
        date: date,
      }.merge(
        types.reduce(Hash.new) {|hash, type|
          hash[type.to_sym] = events_by_date[[type, date]]
          hash
        }
      )
    }
  end

  def to_s
    ballot_name
  end
end
