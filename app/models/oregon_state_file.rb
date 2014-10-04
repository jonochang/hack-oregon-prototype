require 'csv'
class OregonStateFile < ActiveRecord::Base
  has_many :oregon_state_file

  has_attached_file :source_xls_file
  validates_attachment_content_type :source_xls_file, content_type: ["application/excel", "application/vnd.ms-excel", "application/xls", "CDF"]

  has_attached_file :converted_csv_file
  validates_attachment_content_type :converted_csv_file, content_type: ["text/csv", 'text/plain']

  enum data_type: [:transactions]

  def download
    if data_type == 'transactions'
      download_transactions query['from_date'], query['to_date']
    end
  end

  def downloaded_file_url
    case downloaded_file.options[:storage]
      when :filesystem
        URI 'file://', downloaded_file.path
      when :s3
        URI downloaded_file.url
    end
  end

private
  def set_agent
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'#'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36' # Wikipedia blocks "mechanize"
    @agent.log = Logger.new(STDOUT)

    @history = @agent.history
    @base_url = URI 'https://secure.sos.state.or.us'
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
        @export_page  = @agent.click(@results_page.link_with(text: "Export To Excel Format"))
      end
    end

    file = StringIO.new(@export_page.body)
    file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
    file.original_filename = "sos_transactions_#{from_date.strftime("%Y%m%d")}-#{to_date.strftime("%Y%m%d")}-#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xls"
    file.content_type = "xls"

    self.source_xls_file = file
    self.downloaded_at = DateTime.now
  end
end
