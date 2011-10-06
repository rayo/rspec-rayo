module RSpecRayo
  class RayoDriver
    attr_reader :event_queue, :threads
    attr_accessor :calls

    def initialize(options)
      @calls            = {}
      @call_queue       = Queue.new
      @queue_timeout    = options[:queue_timeout] || 5
      @write_timeout    = options[:write_timeout] || 5
      @threads          = []

      initialize_rayo options
    end

    def get_call
      read_queue @call_queue
    end

    def cleanup_calls
      @calls.each_pair do |call_id, call|
        call.hangup unless call.status == :finished
      end
      @calls = {}
    end

    def dial(options)
      Call.new(:protocol => @rayo, :queue => Queue.new, :read_timeout => @queue_timeout, :write_timeout => @write_timeout).tap do |call|
        dial = call.dial options
        call.call_id = dial.call_id
        @calls.merge! call.call_id => call
      end
    end

    def start_event_dispatcher
      @threads << Thread.new do
        event = nil

        until event == 'STOP' do
          event = @event_queue.pop
          case event
          when Punchblock::Event::Offer
            call = Call.new :call_event     => event,
                            :protocol       => @rayo,
                            :queue          => Queue.new,
                            :read_timeout   => @queue_timeout,
                            :write_timeout  => @write_timeout
            @calls.merge! event.call_id => call
            @call_queue.push call
          when Punchblock::Event::Ringing
            call = @calls[event.call_id]
            call.ring_event = event if call
          else
            # Temp based on this nil returned on conference: https://github.com/tropo/punchblock/issues/27
            begin
              if event.is_a?(Punchblock::Event::End)
                @calls[event.call_id].status = :finished
              end
              @calls[event.call_id].queue.push event unless event.nil?
            rescue => error
              # Event nil issue to be addressed here: https://github.com/tropo/rspec-rayo/issues/2
            end
          end
        end

      end
    end

    def read_queue(queue)
      Timeout::timeout(@queue_timeout) { queue.pop }
    end

    def initialize_rayo(options)
      initialize_logging options

      # Setup our Rayo environment
      @rayo = Punchblock::Connection.new  :username         => options[:username],
                                          :password         => options[:password],
                                          :host             => options[:host],
                                          :port             => options[:port],
                                          :wire_logger      => @wire_logger,
                                          :transport_logger => @transport_logger,
                                          :auto_reconnect   => false,
                                          :write_timeout    => options[:write_timeout]
      @event_queue = @rayo.event_queue

      start_rayo
    end

    def initialize_logging(options)
      @wire_logger = options[:wire_logger]
      @wire_logger.level = options[:log_level]
      #@wire_logger.info "Starting up..." if @wire_logger

      @transport_logger = options[:transport_logger]
      @transport_logger.level = options[:log_level]
      #@transport_logger.info "Starting up..." if @transport_logger
    end

    def start_rayo
      # Launch the Rayo thread
      @threads << Thread.new do
        begin
          @rayo.run
        rescue => e
          puts "Exception in XMPP thread! #{e.message}"
          puts e.backtrace.join("\t\n")
        end
      end
    end
  end
end
