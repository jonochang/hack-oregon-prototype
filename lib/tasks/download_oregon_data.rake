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
end

