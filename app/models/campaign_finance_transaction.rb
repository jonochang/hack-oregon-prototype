class CampaignFinanceTransaction < ActiveRecord::Base
  belongs_to :oregon_state_file
  belongs_to :transaction_type
  belongs_to :committee
  belongs_to :transaction_date_entity, class_name: 'Analytics::DateEntity'
  belongs_to :filed_date_entity, class_name: 'Analytics::DateEntity'

  validates :source_id, presence: true, numericality: true
end
