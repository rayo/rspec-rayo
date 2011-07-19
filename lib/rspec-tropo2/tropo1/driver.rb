module Tropo2Utilities
  class Tropo1Driver
    require 'net/http'
    require 'uri'
    require 'countdownlatch'

    attr_accessor :script_content, :result, :drb

    def initialize(uri = nil, latch_timeout = 5)
      @uri            = uri || "druby://0.0.0.0:8787"
      @drb            = DRb.start_service @uri, self
      @latch_timeout  = latch_timeout
      reset!
    end

    def reset!
      @script_content = nil
      @result = nil
      @latches = {}
    end

    def trigger(latch_name)
      @latches[latch_name].tap do |latch|
        latch.countdown! if latch
      end
    end

    def add_latch(latch_name, count = 1)
      @latches[latch_name] ||= CountDownLatch.new count
    end

    def wait(latch_name)
      @latches[latch_name].tap do |latch|
        latch.wait @latch_timeout if latch
      end
    end

    def place_call(session_url)
      Net::HTTP.get URI.parse(session_url)
    end
  end
end
