Paperclip.options[:content_type_mappings] = {
  :xls => "CDF V2 Document, No summary info"
}
Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'
