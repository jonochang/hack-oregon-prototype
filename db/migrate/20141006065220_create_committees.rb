class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.references :oregon_state_file
      t.references :candidate

      t.integer :source_id
      t.string :committee_name
      t.string :committee_type
      t.string :committee_subtype
      t.string :candidate_office
      t.string :candidate_office_group
      t.date :filing_date
      t.integer :filing_date_entity_id
      t.date :organization_filing_date
      t.string :treasurer_first_name
      t.string :treasurer_last_name
      t.string :treasurer_mailing_address
      t.string :treasurer_work_phone
      t.string :treasurer_fax
      t.string :candidate_first_name
      t.string :candidate_last_name
      t.string :candidate_mailing_address
      t.string :candidate_work_phone
      t.string :candidate_residence_phone
      t.string :candidate_fax
      t.string :candidate_email
      t.string :active_election
      t.text :measure

      t.timestamps
    end

    add_index :committees, :oregon_state_file_id
    add_index :committees, :source_id, unique: true
    add_index :committees, :filing_date_entity_id
    add_index :committees, :committee_type
  end
end
