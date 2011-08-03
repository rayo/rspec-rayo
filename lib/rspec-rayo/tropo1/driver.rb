module RSpecRayo
  class Tropo1Driver
    require 'drb'
    require 'net/http'
    require 'uri'
    require 'countdownlatch'

    attr_accessor :script_content, :result, :drb, :config

    def initialize(uri = nil, latch_timeout = 5)
      @uri            = uri || "druby://0.0.0.0:8787"
      @latch_timeout  = latch_timeout
      @config         = {}
      reset!
    end

    def start_drb
      @drb = DRb.start_service @uri, self
    end

    def stop_drb
      @drb.stop_service
    end

    def reset!
      @script_content = nil
      @result = nil
      @latches = {}
    end

    def trigger(latch_name)
      latch = @latches[latch_name]
      raise RuntimeError, "No latch by that name" unless latch
      latch.countdown!
    end

    def add_latch(latch_name, count = 1)
      @latches[latch_name] = CountDownLatch.new count
    end

    def wait(latch_name)
      latch = @latches[latch_name]
      raise RuntimeError, "No latch by that name" unless latch
      latch.wait @latch_timeout
    end

    def place_call(session_url)
      Net::HTTP.get URI.parse(session_url)
    end
  end
end
