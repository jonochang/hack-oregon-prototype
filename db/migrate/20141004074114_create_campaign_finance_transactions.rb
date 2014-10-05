class CreateCampaignFinanceTransactions < ActiveRecord::Migration
  def change
    create_table :campaign_finance_transactions do |t|
      t.references :oregon_state_file
      t.integer :source_id
      t.string :original_id
      t.date :transaction_date
      t.string :transaction_status
      t.string :filer
      t.string :contributor_payee
      t.string :sub_type
      t.decimal :amount
      t.decimal :aggregate_amount
      t.integer :contributor_payee_committee_id
      t.integer :filer_id
      t.string :attest_by_name
      t.date :attest_date
      t.string :review_by_name
      t.date :review_date
      t.date :due_date
      t.date :occptn_ltr_date
      t.text :payment_schedule_txt
      t.string :purpose_description
      t.decimal :interest_rate
      t.string :check_number
      t.string :filed_by_name 
      t.string :tran_stsfd_indicator
      t.date :filed_date
      t.string :addr_book_agent_name
      t.string :book_type
      t.string :title
      t.string :occupation
      t.string :employer_name
      t.string :employer_city
      t.string :employer_state
      t.string :employer_indicator
      t.string :self_employed_indicator
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :zip_plus_four
      t.string :county
      t.string :purpose_codes
      t.date :exp_date

      t.timestamps
    end

    add_index :campaign_finance_transactions, :source_id
    add_index :campaign_finance_transactions, :oregon_state_file_id
    add_index :campaign_finance_transactions, :transaction_date
    add_index :campaign_finance_transactions, :filed_date
  end
end
