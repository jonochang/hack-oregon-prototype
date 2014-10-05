class Api::Analytics::CandidateTransactionsController < ApplicationController
  before_action :set_candidate_transaction, only: [:show]

  def amounts_by_state
    @candidate_transactions = CandidateTransaction.group(:state)
                                                  .select(:state)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end

  def amounts_by_filer
    @candidate_transactions = CandidateTransaction.group(:filer)
                                                  .select(:filer)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end

  def amounts_by_filer_contributor_payee
    @candidate_transactions = CandidateTransaction.group(:filer, :contributor_payee)
                                                  .select(:filer, :contributor_payee)
                                                  .order("sum(amount) DESC")
                                                  .sum(:amount)
  end
end
