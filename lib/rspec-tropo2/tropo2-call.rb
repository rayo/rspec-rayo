module Tropo2Utilities
  class Call
    attr_accessor :call_event, :ring_event
    attr_reader :queue

    def initialize(options)
      @call_event = options[:call_event]
      @protocol   = options[:protocol]
      @queue      = options[:queue]
      @timeout    = options[:timeout] || 5
    end

    def accept
      write @protocol.class::Command::Accept.new
    end

    def answer
      write @protocol.class::Command::Answer.new
    end

    def ask(options)
      write @protocol.class::Command::Ask.new(options)
    end

    def conference(options)
      write @protocol.class::Command::Conference.new(options)
    end

    def dial(options)
      write @protocol.class::Command::Dial.new(options)
    end

    def hangup
      write @protocol.class::Command::Hangup.new
    end

    def redirect(options)
      write @protocol.class::Command::Redirect.new(options)
    end

    def reject(reason=nil)
      write @protocol.class::Command::Reject.new(reason)
    end

    def say(options)
      write @protocol.class::Command::Say.new(options)
    end

    def transfer(options)
      write @protocol.class::Command::Transfer.new(options)
    end

    def last_event?(timeout=nil)
      timeout = timeout || 2
      true if next_event(timeout) == "execution expired"
    end

    def next_event(timeout=nil)
      timeout = timeout || @timeout
      queue_item = nil
      begin
        Timeout::timeout(timeout) {
          queue_item = @queue.pop
        }
      rescue Timeout::Error => e
        queue_item = e.to_s
      end
      queue_item
    end

    private

    def write(msg)
      @protocol.write @call_event, msg
    end
  end
end
