class Api::CampaignFinanceTransactionsController < ApplicationController
  before_action :set_candidate
  before_action :set_campaign_finance_transaction, only: [:show]

  def index
    @campaign_finance_transactions = @candidate.campaign_finance_transactions
  end

  def show
  end

  private
    def set_candidate
      @candidate = Candidate.find(params[:candidate_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_finance_transaction
      @campaign_finance_transaction = @candidate.campaign_finance_transactions.find(params[:id])
    end
end
