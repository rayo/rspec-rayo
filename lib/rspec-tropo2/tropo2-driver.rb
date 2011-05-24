module Tropo2Utilities
  class Tropo2Driver
    attr_reader :event_queue, :threads
    
    def initialize(options)
      @queue_timeout = options[:timeout] || 5
      initialize_tropo2 options
    end
    
    def answer(call_event)
      @tropo2.write call_event, @protocol::Message::Answer.new
      read_event_queue
    end
    
    def ask(prompt, options)
    end
    
    def hangup(call_event)
      @tropo2.write call_event, @protocol::Message::Hangup.new
      read_event_queue
    end
    
    def say()
    end
    
    def last_event?(timeout=nil)
      timeout = timeout || 2
      true if read_event_queue(timeout) == "execution expired"
    end
    
    ##
    # Wrap queue reads in a timeout
    def read_event_queue(timeout=nil)
      timeout = @queue_timeout if timeout.nil?

      queue_item = nil
      begin
        Timeout::timeout(timeout) {
          queue_item = @tropo2.event_queue.pop
        }
      rescue Timeout::Error => e
        queue_item = e.to_s
      end
      queue_item
    end
    
    private
    
    def initialize_tropo2(options)
      #initialize_logging options
      
      # Setup our Ozone environment
      @protocol = Punchblock::Protocol::Ozone
      @tropo2  = Punchblock::Transport::XMPP.new @protocol,
                                                 { :username         => options[:username],
                                                   :password         => options[:password] }
                                                   #:wire_logger      => @wire_logger,
                                                   #:transport_logger => @transport_logger }
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