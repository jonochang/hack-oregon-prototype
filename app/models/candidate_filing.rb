class CandidateFiling < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :oregon_state_file

  validates :candidate, presence: true
  validates :candidate_filing_source_id, presence: true, numericality: true
end
