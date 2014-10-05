json.campaign_finance_transactions @campaign_finance_transactions do |(filer, contributor_payee), amounts|
  json.filer               filer
  json.contributor_payee   contributor_payee
  json.amounts             amounts
end
