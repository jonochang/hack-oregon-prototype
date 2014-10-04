namespace :data do
  desc 'Download Candidate Transactions'
  task :download_transactions => :environment do
    Rake::Task['data:download_transactions_for'].invoke(Date.today.strftime("%Y-%m-%d"), Date.today.strftime("%Y-%m-%d"))
  end

  desc 'Download Candidate Transactions eg., download_transactions[2014-10-01,2014-10-03]'
  task :download_transactions_for, [:from, :to] => :environment do |t, args|
    (Date.parse(args[:from])..Date.parse(args[:to])).each do |date|
      puts "RAKE :: Downloading Oregon State Transactions for #{date}"
      f = OregonStateFile.new data_type: :transactions, query: {from_date: date, to_date: date}
      f.download
      f.save!
    end
  end

  desc 'Convert Outstanding Candidate Transactions to csv'
  task :convert_transactions => :environment do
    OregonStateFile.where(converted_csv_file_file_name: nil).each do |f|
      puts "RAKE :: Converting #{f.id} - #{f.data_type} - #{f.query} from xls to csv"
      f.convert_to_csv
      f.save!
    end
  end

  desc 'Process Candidate Transactions (download, covert, import) eg., process_transactions[2014-10-01,2014-10-03]'
  task :process_transactions_for, [:from, :to] => :environment do |t, args|
    (Date.parse(args[:from])..Date.parse(args[:to])).each do |date|
      puts "RAKE :: Downloading Oregon State Transactions for #{date}"
      f = OregonStateFile.new data_type: :transactions, query: {from_date: date, to_date: date}
      f.download
      f.save!
      puts "RAKE :: Converting Oregon State Transactions for #{date}"
      f.convert_to_csv
      f.save!
      puts "RAKE :: Importing Oregon State Transactions for #{date}"
      f.import!
    end
  end
end

