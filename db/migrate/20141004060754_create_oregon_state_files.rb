class CreateOregonStateFiles < ActiveRecord::Migration
  def change
    create_table :oregon_state_files do |t|
      t.integer :data_type
      t.json :query
      t.attachment :downloaded_file
      t.datetime :downloaded_at

      t.timestamps
    end
  end
end
