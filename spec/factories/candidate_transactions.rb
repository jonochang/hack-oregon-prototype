# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign_finance_transaction do
    source_id 1
    original_id "MyString"
    transaction_date "2014-10-04"
    transaction_status "MyString"
    filer "MyString"
    contributor_payee "MyString"
    sub_type "MyString"
    amount "9.99"
    aggregate_amount "9.99"
    contributor_payee_committee_id 1
    filer_id 1
    attest_by_name "MyString"
    attest_date "2014-10-04"
    review_by_name "MyString"
    review_date "2014-10-04"
    due_date "2014-10-04"
    occptn_ltr_date "2014-10-04"
    payment_schedule_txt "MyText"
    purpose_description "MyString"
    interest_rate "9.99"
    check_number "MyString"
    tran_stsfd_indicator ""
    filed_date "2014-10-04"
    addr_book_agent_name "MyString"
    book_type "MyString"
    title "MyString"
    occupation "MyString"
    employer_name "MyString"
    employer_city "MyString"
    employer_state "MyString"
    employer_indicator "MyString"
    self_employed_indicator "MyString"
    address_line1 "MyString"
    address_line2 "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    zip_plus_four "MyString"
    county "MyString"
    purpose_codes "MyString"
    exp_date "2014-10-04"
  end
end
