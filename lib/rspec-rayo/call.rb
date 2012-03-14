require 'future-resource'

module RSpecRayo
  class Call
    attr_accessor :status, :call_id
    attr_reader :queue

    def initialize(options)
      @offer_event    = FutureResource.new
      @ring_event     = FutureResource.new
      @queue          = Queue.new

      @client         = options[:client]
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

    def offer_event
      @offer_event.resource @read_timeout
    end

    def offer_event=(other)
      pb_logger.debug "Setting offer_event to #{other.inspect}"
      @offer_event.resource  = other
      @offer_id              = other.call_id
    end

    def ring_event(timeout = @read_timeout)
      @ring_event.resource timeout
    end

    def ring_event=(other)
      pb_logger.debug "Setting ring_event to #{other.inspect}"
      @ring_event.resource = other
    end

    def <<(event)
      pb_logger.debug "Processing event #{event.inspect}"
      case event
      when Punchblock::Event::Offer
        pb_logger.debug "Received an offer event"
        self.offer_event = event
      when Punchblock::Event::Ringing
        pb_logger.debug "Received a ringing event"
        self.ring_event = event
      when Punchblock::Event::End
        pb_logger.debug "Received an end event"
        @status = :finished
      end
      @queue << event if event
    end

    private

    def write(msg)
      response = @client.execute_command msg, :call_id => @call_id, :async => false
      msg if response
    end
  end
end
