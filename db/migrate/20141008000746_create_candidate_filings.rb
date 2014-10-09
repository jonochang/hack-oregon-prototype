class CreateCandidateFilings < ActiveRecord::Migration
  def change
    create_table :candidate_filings do |t|
      t.references :candidate
      t.references :oregon_state_file

      t.string :election_title
      t.integer :election_year
      t.string :office_group
      t.integer :candidate_source_id
      t.string :office
      t.string :candidate_office
      t.integer :candidate_filing_source_id
      t.string :file_method_indicator
      t.string :filetype_descr
      t.string :party_affiliation
      t.string :major_party_indicator
      t.string :candidate_ballot_name
      t.text :candidate_occupation
      t.text :candidate_education_background
      t.text :candidate_occupation_background
      t.text :candidate_credentials
      t.text :previous_government_background
      t.string :judge_incumbent_indicator
      t.string :qlf_indicator
      t.date :filed_date
      t.date :file_fee_refund_date
      t.date :withdraw_date
      t.string :withdraw_reason
      t.date :petition_file_date
      t.string :petition_sgnr_rqd_number
      t.string :petition_signatory_filed_number
      t.date :petition_completed_date
      t.integer :ballot_order_number
      t.string :prefix_name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix_name
      t.string :title
      t.string :mailing_address_line_1
      t.string :mailing_address_line_2
      t.string :mailing_city
      t.string :mailing_state
      t.string :mailing_zip_code
      t.string :mailing_zip_plus_four
      t.string :residence_address_line_1
      t.string :residence_address_line_2
      t.string :residence_city
      t.string :residence_state
      t.string :residence_zip_code
      t.string :residence_zip_plus_four
      t.string :home_phone
      t.string :cell_phone
      t.string :fax_phone
      t.string :email
      t.string :work_phone
      t.string :web_address

      t.timestamps
    end

    add_index :candidate_filings, :candidate_filing_source_id, unique: true
    add_index :candidate_filings, :candidate_id
    add_index :candidate_filings, :oregon_state_file_id
  end
end
