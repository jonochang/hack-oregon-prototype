class TransactionType < ActiveRecord::Base
  enum direction: [:in, :out]
end
