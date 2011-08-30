require 'future-resource'

module RSpecRayo
  class Call
    attr_accessor :status, :call_id
    attr_reader :queue

    def initialize(options)
      @call_event     = FutureResource.new
      self.call_event = options[:call_event] if options[:call_event]
      @ring_event     = FutureResource.new
      @protocol       = options[:protocol]
      @queue          = options[:queue]
      @read_timeout   = options[:read_timeout] || 5
      @write_timeout  = options[:write_timeout] || 5
      @status         = :offered
    end

    def accept
      write(Punchblock::Command::Accept.new).tap do |response|
        @status = :accepted if response
      end
    end

    def answer
      write Punchblock::Command::Answer.new
    end

    def ask(options = {})
      write Punchblock::Component::Tropo::Ask.new(options)
    end

    def conference(options = {})
      write Punchblock::Component::Tropo::Conference.new(options)
    end

    def dial(options = {})
      write Punchblock::Command::Dial.new(options)
    end

    def hangup
      write(Punchblock::Command::Hangup.new).tap do |response|
        @status = :finished if response
      end
    end

    def redirect(options = {})
      write Punchblock::Command::Redirect.new(options)
    end

    def reject(reason = nil)
      write(Punchblock::Command::Reject.new(reason)).tap do |response|
        @status = :finished if response
      end
    end

    def say(options = {})
      write Punchblock::Component::Tropo::Say.new(options)
    end

    def transfer(options = {})
      write Punchblock::Component::Tropo::Transfer.new(options)
    end

    def record(options = {})
      write Punchblock::Component::Record.new(options)
    end

    def output(options = {})
      write Punchblock::Component::Output.new(options)
    end

    def input(options = {})
      write Punchblock::Component::Input.new(options)
    end

    def join(options = {})
      write Punchblock::Command::Join.new(options)
    end

    def unjoin(options = {})
      write Punchblock::Command::Unjoin.new(options)
    end

    def mute
      write Punchblock::Command::Mute.new
    end

    def unmute
      write Punchblock::Command::Unmute.new
    end

    def dtmf(tones)
      write Punchblock::Command::DTMF.new(:tones => tones)
    end

    def last_event?(timeout = 2)
      begin
        next_event timeout
      rescue Timeout::Error
        true
      end
    end

    def next_event(timeout = nil)
      Timeout::timeout(timeout || @read_timeout) { @queue.pop }
    end

    def call_event
      @call_event.resource @write_timeout
    end

    def call_event=(other)
      raise ArgumentError, 'Call event must be a Punchblock::Event::Offer' unless other.is_a? Punchblock::Event::Offer
      @call_event.resource  = other
      @call_id              = other.call_id
    end

    def ring_event
      @ring_event.resource @write_timeout
    end

    def ring_event=(other)
      raise ArgumentError, 'Ring event must be a Punchblock::Event::Ringing' unless other.is_a? Punchblock::Event::Ringing
      @ring_event.resource = other
    end

    private

    def write(msg)
      response = @protocol.write @call_id, msg
      msg if response
    end
  end
end
