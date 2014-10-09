class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :candidate_source_id
      t.string :party_affiliation
      t.string :major_party_indicator
      t.string :ballot_name
      t.text :occupation
      t.text :education_background
      t.text :occupation_background
      t.text :credentials
      t.text :previous_government_background
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

    add_index :candidates, :candidate_source_id, unique: true
    add_index :candidates, :email
    add_index :candidates, :cell_phone
  end
end
