class CandidatesController < ApplicationController
  autocomplete :candidate, :ballot_name

  def index
    #@candidates = Candidate.all
    records_array = ActiveRecord::Base.connection.execute "WITH amount_ranks AS (
      SELECT c.id,
             c.committee_id,
             co.candidate_id,
             c.filer,
             c.contributor_payee,
             c.sub_type,
             c.amount,
             ROW_NUMBER() OVER (ORDER BY c.amount DESC) AS amount_rank
      FROM campaign_finance_transactions c LEFT OUTER JOIN committees co ON c.committee_id = co.id
      WHERE co.candidate_id IS NOT NULL)
    SELECT a.* from amount_ranks a
    WHERE a.amount_rank <= 10"
    @transactions = CampaignFinanceTransaction.where(id: records_array.map{|result| result['id']}).order('amount DESC')
  end

  def show
    @candidate = Candidate.find(params[:id])
    @candidate_transactions = @candidate.campaign_finance_transactions.order(:transaction_date)
    @transaction_type_summary = @candidate.campaign_finance_transactions.group(:sub_type)
                                          .select(:sub_type)
                                          .sum(:amount)
                                          .sort_by{|k,v| v}
                                          .reverse

    @stats = @candidate.stats_by_date Date.new(2014,8,1), Date.today
    @types = @candidate.campaign_finance_transactions.select(:sub_type).uniq.pluck(:sub_type)

    @stats_for_chart = @types.map{|key|
      {
        key: key,
        values: @stats.map{|v|
            {
              x: v[:date],
              y: v[key.to_sym].to_i
            }
          }
      }
    }
    
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
