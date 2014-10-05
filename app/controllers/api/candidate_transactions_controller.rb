class Api::CandidateTransactionsController < ApplicationController
  before_action :set_candidate_transaction, only: [:show]

  def index
    @candidate_transactions = CandidateTransaction.all
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate_transaction
      @candidate_transaction = CandidateTransaction.find(params[:id])
    end
end
