module Tropo2Utilities
  class Tropo2Driver
    attr_reader :event_queue, :threads
    attr_accessor :calls

    def initialize(options)
      @calls            = {}
      @call_queue       = Queue.new
      @ring_event_queue = Queue.new
      @queue_timeout    = options[:queue_timeout] || 5
      @threads          = []

      initialize_tropo2 options
    end

    def get_call
      read_queue @call_queue
    end

    def dial(options)
      call = Call.new :protocol   => @tropo2,
                      :queue      => Queue.new,
                      :timeout    => @queue_timeout
      call.dial options
      call.ring_event = read_queue @ring_event_queue
      call.call_event = Punchblock::Call.new call.ring_event.call_id, nil, 'x-tropo2-origin' => 'rspec-tropo2'
      @calls.merge! call.call_event.call_id => call
      call
    end

    def start_event_dispatcher
      @threads << Thread.new do
        event = nil

        until event == 'STOP' do
          event = read_queue @event_queue
          case event
          when Punchblock::Call
            queue = Queue.new
            call = Call.new :call_event => event,
                            :protocol   => @tropo2,
                            :queue      => queue,
                            :timeout    => @queue_timeout
            @calls.merge! event.call_id => call
            @call_queue.push call
          when Punchblock::Protocol::Ozone::Event::Ringing
            @ring_event_queue.push event
          else
            # Temp based on this nil returned on conference: https://github.com/tropo/punchblock/issues/27
            begin
              @calls[event.call_id].queue.push event unless event.nil?
            rescue => error
              # Event nil issue to be addressed here: https://github.com/tropo/rspec-tropo2/issues/2
            end
          end
        end

      end
    end

    def read_queue(queue)
      begin
        Timeout::timeout(@queue_timeout) { queue.pop }
      rescue Timeout::Error => e
        e.to_s
      end
    end

    def initialize_tropo2(options)
      initialize_logging options

      # Setup our Ozone environment
      @tropo2  = Punchblock::Protocol::Ozone.new :username          => options[:username],
                                                 :password          => options[:password],
                                                 :wire_logger       => @wire_logger,
                                                 :transport_logger  => @transport_logger,
                                                 :auto_reconnect    => false
      @event_queue = @tropo2.event_queue

      start_tropo2
    end

    def initialize_logging(options)
      @wire_logger = options[:wire_logger]
      @wire_logger.level = options[:log_level]
      #@wire_logger.info "Starting up..." if @wire_logger

      @transport_logger = options[:transport_logger]
      @transport_logger.level = options[:log_level]
      #@transport_logger.info "Starting up..." if @transport_logger
    end

    def start_tropo2
      # Launch the Ozone thread
      @threads << Thread.new do
        begin
          @tropo2.run
        rescue => e
          puts "Exception in XMPP thread! #{e.message}"
          puts e.backtrace.join("\t\n")
        end
      end
    end
  end
end
