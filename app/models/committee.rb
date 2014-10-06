class Committee < ActiveRecord::Base
  belongs_to :oregon_state_file
  belongs_to :filing_date_entity, class_name: 'Analytics::DateEntity'

  validates :source_id, presence: true, numericality: true
end
