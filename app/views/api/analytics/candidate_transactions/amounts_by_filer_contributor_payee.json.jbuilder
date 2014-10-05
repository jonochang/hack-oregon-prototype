json.candidate_transactions @candidate_transactions do |(filer, contributor_payee), amounts|
  json.filer               filer
  json.contributor_payee   contributor_payee
  json.amounts             amounts
end
