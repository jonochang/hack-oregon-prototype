class CampaignFinanceTransaction < ActiveRecord::Base
  belongs_to :oregon_state_file

  validates :source_id, presence: true, numericality: true
end
