module Tropo2Utilities
  class Tropo2Driver
    attr_reader :event_queue, :threads
    attr_accessor :calls
    
    def initialize(options)
      @calls         = {}
      @call_queue    = Queue.new
      @queue_timeout = options[:queue_timeout] || 5
      
      initialize_tropo2 options
    end
    
    def get_call
      @call_queue.pop
    end
    
    def start_event_dispatcher
      @threads << Thread.new do
        event = nil
        
        until event == 'STOP' do
          event = @event_queue.pop
          case event.class.to_s
          when 'Punchblock::Call'
            queue = Queue.new
            call = Call.new({ :call_event => event,
                              :punchblock => @tropo2,
                              :protocol   => @protocol,
                              :queue      => queue,
                              :timeout    => @queue_timeout  })
            @calls.merge!({ event.call_id => call })
            @call_queue.push call
          else
            # Temp based on this: https://github.com/tropo/punchblock/issues/27
            @calls[event.call_id].queue.push event unless event.nil?
          end
        end
        
      end
    end
    
    def read_event_queue
      queue_item = nil
      begin
        Timeout::timeout(@queue_timeout) {
          queue_item = @event_queue.pop
        }
      rescue Timeout::Error => e
        queue_item = e.to_s
      end
      queue_item
    end
    
    def initialize_tropo2(options)
      initialize_logging options
      
      # Setup our Ozone environment
      @protocol = Punchblock::Protocol::Ozone
      @tropo2  = Punchblock::Transport::XMPP.new @protocol,
                                                 { :username         => options[:username],
                                                   :password         => options[:password],
                                                   :wire_logger      => @wire_logger,
                                                   :transport_logger => @transport_logger }
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
      @threads = []
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