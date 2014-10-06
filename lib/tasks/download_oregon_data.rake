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

  desc 'Download Committees eg., download_committees[A,Z]'
  task :download_committees_for, [:from, :to] => :environment do |t, args|
    (args[:from]..args[:to]).each do |starts_with_name|
      puts "RAKE :: Downloading Oregon State Committees starting with #{starts_with_name}"
      f = OregonStateFile.new data_type: :committees, query: {starts_with_name: starts_with_name}
      f.download
      f.save!
    end
  end

  desc 'Process Committees (download, covert, import) eg., process_committees_for[A,Z]'
  task :process_committees_for, [:from, :to] => :environment do |t, args|
    (args[:from]..args[:to]).each do |starts_with_name|
      puts "RAKE :: Downloading Oregon State Committees starting with #{starts_with_name}"
      f = OregonStateFile.new data_type: :committees, query: {starts_with_name: starts_with_name}
      f.download
      f.save!
      if f.source_xls_file.exists?
        puts "RAKE :: Converting Oregon State Committees for #{starts_with_name}"
        f.convert_to_csv
        f.save!
        if f.converted_csv_file.exists?
          puts "RAKE :: Importing Oregon State Committees for #{starts_with_name}"
          f.import!
        end
      end
    end
  end
end

