# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file .env file.

TransactionType.transaction do
  [['Account Payable Rescinded', nil],
   ['Account Payable', :out],
   ['Cash Balance Adjustment', nil],
   ['Cash Contribution', :in],
   ['Cash Expenditure', :out],
   ['Expenditure Made by an Agent', :out],
   ['In-Kind Contribution', :in],
   ['In-Kind/Forgiven Account Payable', :in],
   ['In-Kind/Forgiven Personal Expenditures', :in],
   ['Interest/Investment Income', :in],
   ['Items Sold at Fair Market Value', :in],
   ['Loan Forgiven (Non-Exempt)', :in],
   ['Loan Payment (Exempt)', :out],
   ['Loan Payment (Non-Exempt)', :out],
   ['Loan Received (Exempt)', :in],
   ['Loan Received (Non-Exempt)', :in],
   ['Lost or Returned Check', :out],
   ['Miscellaneous Account Receivable', :in],
   ['Miscellaneous Other Disbursement', :out],
   ['Miscellaneous Other Receipt', :out],
   ['Nonpartisan Activity', nil],
   ['Personal Expenditure Balance Adjustment', nil],
   ['Personal Expenditure for Reimbursement', :out],
   ['Pledge of Cash', :in],
   ['Pledge of In-Kind', :in],
   ['Pledge of Loan', :in],
   ['Refunds and Rebates', :in],
   ['Return or Refund of Contribution', :out],
   ['Uncollectible Pledge of Cash', :out],
   ['Uncollectible Pledge of In-Kind', :out],
   ['Unexpended Agent Balance', nil]].each do |title, direction|
    TransactionType.create! title: title, direction: direction
  end
end
puts 'CREATED Transaction Types'

