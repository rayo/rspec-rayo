module RSpecRayo
  class Call
    attr_accessor :call_event, :ring_event, :status, :call_id
    attr_reader :queue

    def initialize(options)
      @call_event = options[:call_event]
      @call_id    = @call_event.call_id if @call_event
      @protocol   = options[:protocol]
      @queue      = options[:queue]
      @timeout    = options[:timeout] || 5
      @status     = :offered
    end

    def accept
      write(@protocol.class::Command::Accept.new).tap do |response|
        @status = :accepted if response
      end
    end

    def answer
      write @protocol.class::Command::Answer.new
    end

    def ask(options = {})
      write @protocol.class::Command::Tropo::Ask.new(options)
    end

    def conference(options = {})
      write @protocol.class::Command::Tropo::Conference.new(options)
    end

    def dial(options = {})
      write @protocol.class::Command::Dial.new(options)
    end

    def hangup
      write(@protocol.class::Command::Hangup.new).tap do |response|
        @status = :finished if response
      end
    end

    def redirect(options = {})
      write @protocol.class::Command::Redirect.new(options)
    end

    def reject(reason = nil)
      write(@protocol.class::Command::Reject.new(reason)).tap do |response|
        @status = :finished if response
      end
    end

    def say(options = {})
      write @protocol.class::Command::Tropo::Say.new(options)
    end

    def transfer(options = {})
      write @protocol.class::Command::Tropo::Transfer.new(options)
    end

    def record(options = {})
      write @protocol.class::Command::Record.new(options)
    end

    def output(options = {})
      write @protocol.class::Command::Output.new(options)
    end

    def input(options = {})
      write @protocol.class::Command::Input.new(options)
    end

    def join(options = {})
      write @protocol.class::Command::Join.new(options)
    end

    def unjoin(options = {})
      write @protocol.class::Command::Unjoin.new(options)
    end

    def mute
      write @protocol.class::Command::Mute.new
    end

    def unmute
      write @protocol.class::Command::Unmute.new
    end

    def last_event?(timeout = 2)
      begin
        next_event timeout
      rescue Timeout::Error
        true
      end
    end

    def next_event(timeout = nil)
      Timeout::timeout(timeout || @timeout) { @queue.pop }
    end

    private

    def write(msg)
      response = @protocol.write @call_id, msg
      msg if response
    end
  end
end
