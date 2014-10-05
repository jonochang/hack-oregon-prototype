json.candidate_transactions @candidate_transactions do |trans|
  json.(trans, :id, :source_id, :original_id,
               :transaction_date,
               :transaction_status,
               :amount,
               :filed_date,
               :filer_id,
               :filer)
end

