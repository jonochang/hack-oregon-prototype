require 'csv'
class OregonStateFile < ActiveRecord::Base
  has_many :campaign_finance_transactions

  has_attached_file :source_xls_file
  validates_attachment_content_type :source_xls_file, content_type: ["application/excel", "application/vnd.ms-excel", "application/xls", "CDF"]

  has_attached_file :converted_csv_file,
    s3_headers: lambda { |attachment|
      { 
        'Content-Type' => 'text/csv',
        'Content-Disposition' => "attachment; filename=#{attachment.send(:original_filename)}",
      }
    }
  validates_attachment_content_type :converted_csv_file, content_type: ["text/csv", 'text/plain', 'text/x-pascal', 'application/octet-stream']

  enum data_type: [:transactions, :committees, :candidate_filings]

  def download
    case data_type
    when 'transactions'
      download_transactions query['from_date'], query['to_date']
    when 'committees'
      download_committees query['starts_with_name']
    when 'candidate_filings'
      download_candidate_filings query['from_date'], query['to_date']
    end
  end

  def convert_to_csv
    raise 'can not convert to csv without a source excel file' unless source_xls_file.exists?
    file = Tempfile.new(['xls2csv-', '.xls'])
    file.binmode
    begin
      file.write(open(source_xls_file_uripath) {|f| f.read })
      file.rewind

      xls2csv = File.expand_path Rails.application.secrets.xls2csv
      data = `#{xls2csv} #{file.path}`

      uri = URI.parse(source_xls_file.url)
      filename = File.basename(uri.path)

      csv = StringIO.new(data)
      csv.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
      csv.original_filename = "#{filename}.csv"
      csv.content_type = "text/plain"
      
      self.converted_csv_file = csv
      self.converted_at = DateTime.now
    ensure
      file.close
      file.unlink
    end
  end
  
  def import!
    case data_type
    when 'transactions'
      import_transactions!
    when 'committees'
      import_committees!
    when 'candidate_filings'
      import_candidate_filings!
    end
  end

  def source_xls_file_uripath
    uri_path source_xls_file
  end

  def converted_csv_file_uripath
    uri_path converted_csv_file
  end

private
  def parse_date source
    return nil if source.to_s.strip.empty?
    Date.strptime(source, '%m/%d/%Y')
  end

  def uri_path attachment
    return nil unless attachment.exists?
    case attachment.options[:storage]
    when :filesystem
      attachment.path
    when :s3
      attachment.url(:original, timestamp: false)
    else
      raise 'unsupported paperclip storage'
    end
  end

  def set_agent
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'#'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36' # Wikipedia blocks "mechanize"
    @agent.log = Logger.new(STDOUT)

    @history = @agent.history
    @base_url = URI 'https://secure.sos.state.or.us'
  end

  def set_source_xls_file_and_downloaded_at body, filename
    file = StringIO.new(body)
    file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
    file.original_filename = filename
    file.content_type = "xls"

    self.source_xls_file = file
    self.downloaded_at = DateTime.now
  end

  def download_transactions from, to
    from_date = case from
      when Date
        from
      when String
        Date.parse from
      else
        raise 'invalid from date'
    end

    to_date = case to
      when Date
        from
      when String
        Date.parse to
      else
        raise 'invalid to date'
    end

    set_agent

    @agent.get("#{@base_url}/orestar/gotoPublicTransactionSearch.do") do |search_page|
      search_page.form_with(name: 'cneSearchForm') do |form|
        form.cneSearchTranFiledStartDate = from_date.strftime("%m/%d/%Y")
        form.cneSearchTranFiledEndDate = to_date.strftime("%m/%d/%Y")

        @results_page = @agent.submit(form, form.button_with(value: "Search"))
        if link = @results_page.link_with(text: "Export To Excel Format")
          @export_page  = @agent.click(link)
          set_source_xls_file_and_downloaded_at @export_page.body, "sos_transactions_#{from_date.strftime("%Y%m%d")}-#{to_date.strftime("%Y%m%d")}-#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xls"
        end
      end
    end

  end

  def download_committees starts_with_name
    set_agent

    @agent.get("#{@base_url}/orestar/GotoSearchByName.do") do |search_page|
      @results_page = @agent.post('https://secure.sos.state.or.us/orestar/CommitteeSearchFirstPage.do', {
        buttonName: '',
        page: 100,
        committeeName: starts_with_name,
        committeeNameMultiboxText: 'starts',
        committeeId: '',
        firstName: '',
        firstNameMultiboxText: 'contains',
        lastName: '',
        lastNameMultiboxText: 'contains',
        discontinuedSOO: 'on',
        submit: 'Submit',
        approvedSOO: 'true',
        pendingApprovalSOO: 'false',
        insufficientSOO: 'false',
        resolvedSOO: 'false',
        rejectedSOO: 'false'
      }) 

      if link = @results_page.link_with(text: "Export To Excel Format")
        @export_page  = @agent.click(link)
        set_source_xls_file_and_downloaded_at @export_page.body, "sos_committees_#{starts_with_name}-#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xls"
      end
    end
  end

  def download_candidate_filings from, to
    from_date = case from
      when Date
        from
      when String
        Date.parse from
      else
        raise 'invalid from date'
    end

    to_date = case to
      when Date
        from
      when String
        Date.parse to
      else
        raise 'invalid to date'
    end

    set_agent

    @agent.get("#{@base_url}/orestar/CFSearchPage.do") do |search_page|
      search_page.form_with(name: 'cfSearchPageForm') do |form|
        form.cfFilingFromDate = from_date.strftime("%m/%d/%Y")
        form.cfFilingToDate = to_date.strftime("%m/%d/%Y")

        @results_page = @agent.submit(form, form.button_with(value: "Submit"))
        if link = @results_page.link_with(text: "Export")
          @export_page  = @agent.click(link)
          set_source_xls_file_and_downloaded_at @export_page.body, "sos_candidates_#{from_date.strftime("%Y%m%d")}-#{to_date.strftime("%Y%m%d")}-#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xls"
        end
      end

      #@results_page = @agent.post('https://secure.sos.state.or.us/orestar/cfFilings.do', {
      #  cfSearchButtonName: '',
      #  cfName: '',
      #  cfyearActive: '',
      #  cfElection: '',
      #  cfOffice: '',
      #  cfPartyAffiliation: '',
      #  cfFilingType: '',
      #  cfFilingFromDate: from_date.strftime("%m/%d/%Y"),
      #  cfFilingToDate: to_date.strftime("%m/%d/%Y"),
      #  cfWithDrawFromDate: '',
      #  cfWithDrawToDate: ''
      #}) 

      #if link = @results_page.link_with(text: "Export To Excel Format")
      #  @export_page  = @agent.click(link)
      #end
    end
  end

  def import_transactions!
    raise 'can not import without a converted csv file' unless converted_csv_file.exists?
    CampaignFinanceTransaction.where(oregon_state_file_id: self.id).delete_all

    CSV.parse(open(converted_csv_file_uripath).read) do |row|
      trans_id, original_id, tran_date, tran_status, filer, contributor_payee, sub_type, amount, aggregate_amount, 
      contributor_payee_committee_id, filer_id, attest_by_name, attest_date, review_by_name, review_date, due_date, 
      occptn_ltr_date, pymt_sched_txt, purp_desc, intrst_rate, check_nbr, tran_stsfd_ind, filed_by_name, filed_date, 
      addr_book_agent_name, book_type, title_txt, occptn_txt, emp_name, emp_city, emp_state, employ_ind, self_employ_ind, 
      addr_line1, addr_line2, city, state, zip, zip_plus_four, county, purpose_codes, exp_date = row
      
      next if trans_id == 'Tran Id' || trans_id.to_s.strip.empty?
      CampaignFinanceTransaction.create! oregon_state_file: self,
        transaction_type: TransactionType.where(title: sub_type).first,
        committee: Committee.where(source_id: filer_id).first,
        transaction_date_entity: Analytics::DateEntity.where(full_date: parse_date(tran_date)).first,
        filed_date_entity: Analytics::DateEntity.where(full_date: parse_date(filed_date)).first,
        source_id: trans_id,
        original_id: original_id,
        transaction_date: parse_date(tran_date), 
        transaction_status: tran_status, 
        filer: filer,
        contributor_payee: contributor_payee,
        sub_type: sub_type,
        amount: amount,
        aggregate_amount: aggregate_amount,
        contributor_payee_committee_id: contributor_payee_committee_id,
        filer_id: filer_id,
        attest_by_name: attest_by_name,
        attest_date: parse_date(attest_date),
        review_by_name: review_by_name,
        review_date: parse_date(review_date),
        due_date: parse_date(due_date),
        occptn_ltr_date: parse_date(occptn_ltr_date),
        payment_schedule_txt: pymt_sched_txt,
        purpose_description: purp_desc,
        interest_rate: intrst_rate,
        check_number: check_nbr,
        tran_stsfd_indicator: tran_stsfd_ind,
        filed_by_name: filed_by_name,
        filed_date: parse_date(filed_date),
        addr_book_agent_name: addr_book_agent_name,
        book_type: book_type,
        title: title_txt,
        occupation: occptn_txt,
        employer_name: emp_name,
        employer_city: emp_city,
        employer_state: emp_state,
        employer_indicator: employ_ind,
        self_employed_indicator: self_employ_ind,
        address_line1: addr_line1,
        address_line2: addr_line2,
        city: city,
        state: state,
        zip: zip,
        zip_plus_four: zip_plus_four,
        county: county,
        purpose_codes: purpose_codes,
        exp_date: parse_date(exp_date)
    end
  end

  def import_committees!
    raise 'can not import without a converted csv file' unless converted_csv_file.exists?
    Committee.where(oregon_state_file_id: self.id).delete_all

    CSV.parse(open(converted_csv_file_uripath).read) do |row|
      committee_id, committee_name, committee_type, committee_subtype, candidate_office, candidate_office_group, 
      filing_date, organization_filing_date, treasurer_first_name, treasurer_last_name, treasurer_mailing_address, 
      treasurer_work_phone, treasurer_fax, candidate_first_name, candidate_last_name, candidate_maling_address, 
      candidate_work_phone, candidate_residence_phone, candidate_fax, candidate_email, active_election, measure = row
      
      next if committee_id == 'Committee Id' || committee_id.to_s.strip.empty?

      begin
        candidate = Candidate.where(email: candidate_email).first
        committee = Committee.find_or_create_by source_id: committee_id
        committee.update_attributes! oregon_state_file: self,
          candidate: candidate,
          committee_name: committee_name,
          committee_type: committee_type,
          committee_subtype: committee_subtype,
          candidate_office: candidate_office,
          candidate_office_group: candidate_office_group,
          filing_date: parse_date(filing_date),
          filing_date_entity: Analytics::DateEntity.where(full_date: parse_date(filing_date)).first,
          organization_filing_date: parse_date(organization_filing_date), 
          treasurer_first_name: treasurer_first_name,
          treasurer_last_name: treasurer_last_name,
          treasurer_mailing_address: treasurer_mailing_address,
          treasurer_work_phone: treasurer_work_phone,
          treasurer_fax: treasurer_fax,
          candidate_first_name: candidate_first_name,
          candidate_last_name: candidate_last_name,
          candidate_mailing_address: candidate_maling_address,
          candidate_work_phone: candidate_work_phone,
          candidate_residence_phone: candidate_residence_phone,
          candidate_fax: candidate_fax,
          candidate_email: candidate_email,
          active_election: active_election,
          measure: measure
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end

  def import_candidate_filings!
    raise 'can not import without a converted csv file' unless converted_csv_file.exists?
    CandidateFiling.where(oregon_state_file_id: self.id).delete_all

    CSV.parse(open(converted_csv_file_uripath).read) do |row|
      election_txt, election_year, office_group, id_nbr, office, candidate_office, candidate_file_rsn, file_mthd_ind, 
      filetype_descr, party_descr, major_party_ind, cand_ballot_name_txt, occptn_txt, education_bckgrnd_txt, occptn_bkgrnd_txt, 
      credentials, prev_govt_bkgrnd_txt, judge_incbnt_ind, qlf_ind, filed_date, file_fee_rfnd_date, witdrw_date, withdrw_resn_txt, 
      pttn_file_date, pttn_sgnr_rqd_nbr, pttn_signr_filed_nbr, pttn_cmplt_date, ballot_order_nbr, prfx_name_cd, first_name, mdle_name, 
      last_name, sufx_name, title_txt, mailing_addr_line_1, mailing_addr_line_2, mailing_city_name, mailing_st_cd, mailing_zip_code, mailing_zip_plus_four, 
      residence_addr_line_1, residence_addr_line_2, residence_city_name, residence_st_cd, residence_zip_code, residence_zip_plus_four, home_phone, cell_phone, 
      fax_phone, email, work_phone, web_address = row

      next if election_txt == 'Election Txt' || election_txt.to_s.strip.empty?

      begin
        candidate = Candidate.find_or_create_by candidate_source_id: id_nbr
        candidate.update_attributes! party_affiliation: party_descr,
          major_party_indicator: major_party_ind,
          ballot_name: cand_ballot_name_txt,
          occupation: occptn_txt,
          education_background: education_bckgrnd_txt,
          occupation_background: occptn_bkgrnd_txt,
          credentials: credentials,
          previous_government_background: prev_govt_bkgrnd_txt,
          prefix_name: prfx_name_cd,
          first_name: first_name,
          middle_name: mdle_name,
          last_name: last_name,
          suffix_name: sufx_name,
          title: title_txt,
          mailing_address_line_1: mailing_addr_line_1,
          mailing_address_line_2: mailing_addr_line_2,
          mailing_city: mailing_city_name,
          mailing_state: mailing_st_cd,
          mailing_zip_code: mailing_zip_code,
          mailing_zip_plus_four: mailing_zip_plus_four,
          residence_address_line_1: residence_addr_line_1,
          residence_address_line_2: residence_addr_line_2,
          residence_city: residence_city_name,
          residence_state: residence_st_cd,
          residence_zip_code: residence_zip_code,
          residence_zip_plus_four: residence_zip_plus_four,
          home_phone: home_phone,
          cell_phone: cell_phone,
          fax_phone: fax_phone,
          email: email,
          work_phone: work_phone,
          web_address: web_address

        candidate_filing = CandidateFiling.find_or_create_by candidate_filing_source_id: candidate_file_rsn
        candidate_filing.update_attributes! oregon_state_file: self,
          candidate: candidate,
          election_title: election_txt,
          election_year: election_year,
          office_group: office_group,
          candidate_source_id: id_nbr,
          office: office,
          candidate_office: candidate_office,
          file_method_indicator: file_mthd_ind,
          filetype_descr: filetype_descr,
          party_affiliation: party_descr,
          major_party_indicator: major_party_ind,
          candidate_ballot_name: cand_ballot_name_txt,
          candidate_occupation: occptn_txt,
          candidate_education_background: education_bckgrnd_txt,
          candidate_occupation_background: occptn_bkgrnd_txt,
          candidate_credentials: credentials,
          previous_government_background: prev_govt_bkgrnd_txt,
          judge_incumbent_indicator: judge_incbnt_ind,
          qlf_indicator: qlf_ind,
          filed_date: parse_date(filed_date),
          file_fee_refund_date: parse_date(file_fee_rfnd_date),
          withdraw_date: parse_date(witdrw_date),
          withdraw_reason: withdrw_resn_txt,
          petition_file_date: parse_date(pttn_file_date),
          petition_sgnr_rqd_number: pttn_sgnr_rqd_nbr,
          petition_signatory_filed_number: pttn_signr_filed_nbr,
          petition_completed_date: parse_date(pttn_cmplt_date),
          ballot_order_number: ballot_order_nbr,
          prefix_name: prfx_name_cd,
          first_name: first_name,
          middle_name: mdle_name,
          last_name: last_name,
          suffix_name: sufx_name,
          title: title_txt,
          mailing_address_line_1: mailing_addr_line_1,
          mailing_address_line_2: mailing_addr_line_2,
          mailing_city: mailing_city_name,
          mailing_state: mailing_st_cd,
          mailing_zip_code: mailing_zip_code,
          mailing_zip_plus_four: mailing_zip_plus_four,
          residence_address_line_1: residence_addr_line_1,
          residence_address_line_2: residence_addr_line_2,
          residence_city: residence_city_name,
          residence_state: residence_st_cd,
          residence_zip_code: residence_zip_code,
          residence_zip_plus_four: residence_zip_plus_four,
          home_phone: home_phone,
          cell_phone: cell_phone,
          fax_phone: fax_phone,
          email: email,
          work_phone: work_phone,
          web_address: web_address
          
          
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end

  end
end
