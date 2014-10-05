class Api::CampaignFinanceTransactionsController < ApplicationController
  before_action :set_campaign_finance_transaction, only: [:show]

  def index
    @campaign_finance_transactions = CampaignFinanceTransaction.all
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_finance_transaction
      @campaign_finance_transaction = CampaignFinanceTransaction.find(params[:id])
    end
end
