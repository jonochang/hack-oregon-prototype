Paperclip.options[:content_type_mappings] = {
  :xls => "CDF V2 Document, No summary info"
}
Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'

#tried to manually handle different content types that got created, and finally got defeated by a csv registering as octet stream / binary
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
