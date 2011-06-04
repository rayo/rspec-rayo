module Tropo2Utilities
  class Call
    attr_reader :call_event, :queue
    
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
    
    def ask(prompt, options ={})
      @punchblock.write @call_event, @protocol::Ask.new(prompt, options)
    end
    
    def conference(name, options={})
      @punchblock.write @call_event, @protocol::Conference.new(name, options)
    end
    
    def dial(options)
      @punchblock.write @call_event, @protocol::Dial.new(options)
    end
    
    def hangup
      @punchblock.write @call_event, @protocol::Hangup.new
    end

    def redirect(destination)
      @punchblock.write @call_event, @protocol::Redirect.new(destination)
    end
    
    def reject(reason=nil)
      @punchblock.write @call_event, @protocol::Reject.new(reason)
    end
    
    def say(string, type = :text)
      @punchblock.write @call_event, @protocol::Say.new(type => string)
    end
    
    def transfer(to, options={})
      @punchblock.write @call_event, @protocol::Transfer.new(to, options)
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