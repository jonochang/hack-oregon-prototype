# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :candidate do
    candidate_source_id 1
    party_affiliation "MyString"
    major_party_indicator "MyString"
    ballot_name "MyString"
    occupation "MyString"
    education_background "MyText"
    occupation_background "MyText"
    credentials "MyString"
    previous_government_background "MyString"
    prefix_name "MyString"
    first_name "MyString"
    middle_name "MyString"
    last_name "MyString"
    suffix_name "MyString"
    title "MyString"
    mailing_address_line_1 "MyString"
    mailing_address_line_2 "MyString"
    mailing_city "MyString"
    mailing_state "MyString"
    mailing_zip_code "MyString"
    mailing_zip_plus_four "MyString"
    residence_address_line_1 "MyString"
    residence_address_line_2 "MyString"
    residence_city "MyString"
    residence_state "MyString"
    residence_zip_code "MyString"
    residence_zip_plus_four "MyString"
    home_phone "MyString"
    cell_phone "MyString"
    fax_phone "MyString"
    email "MyString"
    work_phone "MyString"
    web_address "MyString"
  end
end
