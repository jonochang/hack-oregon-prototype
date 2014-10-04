class CreateOregonStateFiles < ActiveRecord::Migration
  def change
    create_table :oregon_state_files do |t|
      t.integer :data_type
      t.json :query
      t.attachment :source_xls_file
      t.datetime :downloaded_at
      t.attachment :converted_csv_file
      t.datetime :converted_at
      t.timestamps
    end
  end
end
