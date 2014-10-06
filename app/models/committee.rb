class Committee < ActiveRecord::Base
  belongs_to :oregon_state_file
  belongs_to :filing_date_entity, class_name: 'Analytics::DateEntity'

  has_many :campaign_finance_transactions

  validates :source_id, presence: true, numericality: true
end
