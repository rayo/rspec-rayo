module Tropo2Utilities
  class Call
    attr_accessor :call_event, :ring_event
    attr_reader :queue
    
    def initialize(options)
      @call_event = options[:call_event]
      @punchblock = options[:punchblock]
      @protocol   = options[:protocol]
      @queue      = options[:queue]
      @timeout    = options[:timeout] || 5
    end
    
    def accept
      @punchblock.write @call_event, @protocol::Accept.new
    end
    
    def answer
      @punchblock.write @call_event, @protocol::Answer.new
    end
    
    def ask(options)
      @punchblock.write @call_event, @protocol::Ask.new(options)
    end
    
    def conference(options)
      @punchblock.write @call_event, @protocol::Conference.new(options)
    end
    
    def dial(options)
      @punchblock.write @call_event, @protocol::Dial.new(options)
    end
    
    def hangup
      @punchblock.write @call_event, @protocol::Hangup.new
    end

    def redirect(options)
      @punchblock.write @call_event, @protocol::Redirect.new(options)
    end
    
    def reject(reason=nil)
      @punchblock.write @call_event, @protocol::Reject.new(reason)
    end
    
    def say(options)
      @punchblock.write @call_event, @protocol::Say.new(options)
    end
    
    def transfer(options)
      @punchblock.write @call_event, @protocol::Transfer.new(options)
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
  end
end