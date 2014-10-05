class Api::Analytics::CampaignFinanceTransactionsController < ApplicationController
  before_action :set_campaign_finance_transaction, only: [:show]

  def amounts_by_state
    @campaign_finance_transactions = CampaignFinanceTransaction.group(:state)
                                                  .select(:state)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end

  def amounts_by_filer
    @campaign_finance_transactions = CampaignFinanceTransaction.group(:filer)
                                                  .select(:filer)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end

  def amounts_by_filer_contributor_payee
    @campaign_finance_transactions = CampaignFinanceTransaction.group(:filer, :contributor_payee)
                                                  .select(:filer, :contributor_payee)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end
end
