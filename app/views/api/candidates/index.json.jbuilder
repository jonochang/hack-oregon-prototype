json.candidates @candidates do |candidate|
  json.(candidate, :id, :ballot_name, :party_affiliation, :email, :cell_phone)
end
