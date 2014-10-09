class Candidate < ActiveRecord::Base
  has_many :candidate_filings
  has_many :committees
  has_many :campaign_finance_transactions, through: :committees

  validates :candidate_source_id, presence: true, numericality: true
end
