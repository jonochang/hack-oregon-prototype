class CandidatesController < ApplicationController

  def index
    @candidates = Candidate.all
  end

  def show
    @candidate = Candidate.find(params[:id])
    @candidate_transactions = @candidate.campaign_finance_transactions.order(:transaction_date)
    @transaction_type_summary = @candidate.campaign_finance_transactions.group(:sub_type)
                                          .select(:sub_type)
                                          .sum(:amount)
                                          .sort_by{|k,v| v}
                                          .reverse

    @transaction_type_summary_for_chart = [
      {
        key: 'Transaction Types',
        values: @transaction_type_summary.map{|k,v|
          {
            label: k.blank? ? 'Unknown' : k,
            value: v
          }
        }
      }
      
    ]
    @transaction_type_max_value = @transaction_type_summary.present? ? @transaction_type_summary.first.last : 0

    @state_summary = @candidate.campaign_finance_transactions.group(:state)
                               .select(:state)
                               .sum(:amount)
                               .sort_by{|k,v| v}
                               .reverse

    @state_summary_for_chart = [
      {
        key: 'States',
        values: @state_summary.map{|k,v|
            {
              label: k.blank? ? 'Unknown' : k,
              value: v
            }
          }
      }
    ]

    @state_max_value = @state_summary.present? ? @state_summary.first.last : 0
  end

end
