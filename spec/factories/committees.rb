# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :committee do
    source_id 1
    committee_name "MyString"
    committee_type "MyString"
    committee_subtype "MyString"
    candidate_office "MyString"
    candidate_office_group "MyString"
    filing_date "2014-10-05"
    filing_date_id 1
    organization_filing_date "2014-10-05"
    treasurer_first_name "MyString"
    treasurer_last_name "MyString"
    treasurer_mailing_address "MyString"
    treasurer_work_phone "MyString"
    treasurer_fax "MyString"
    candidate_first_name "MyString"
    candidate_last_name "MyString"
    candidate_maling_address "MyString"
    candidate_work_phone "MyString"
    candidate_residence_phone "MyString"
    candidate_fax "MyString"
    candidate_email "MyString"
    active_election "MyString"
    measure "MyText"
  end
end
