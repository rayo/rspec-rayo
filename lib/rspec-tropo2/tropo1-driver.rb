module Tropo2Utilities
  class Tropo1Driver
    require 'net/http'
    require 'uri'
    
    attr_accessor :script_content, :result, :drb
    
    def initialize(uri=nil)
      @uri            = uri || "druby://0.0.0.0:8787"
      @script_content = nil
      @tropo_result   = nil
      @drb            = DRb.start_service(@uri, self)
    end
    
    def place_call(session_url)      
      Net::HTTP.get_print URI.parse session_url
    end
  end
end