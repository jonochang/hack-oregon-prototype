class Api::CandidatesController < ApplicationController
  def index
    @candidates = Candidate.order(:ballot_name)
  end
end
