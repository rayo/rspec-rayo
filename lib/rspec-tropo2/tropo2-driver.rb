module Tropo2Utilities
  class Tropo2Driver
    attr_reader :event_queue, :threads
    
    def initialize(options)
      @queue_timeout = options[:timeout] || 5
      initialize_tropo2 options
    end
    
    def answer
      @tropo2.write @call_event, @protocol::Message::Answer.new
      read_event_queue
      # Reading a second time based on this bug: https://evolution.voxeo.com/ticket/1441822
      read_event_queue
    end
    
    def ask(prompt, choices, options ={})
      @tropo2.write @call_event, @protocol::Message::Ask.new(prompt, choices, options)
      read_event_queue unless get_method_name == 'ask_nonblocking'
    end
    alias :ask_nonblocking :ask
    
    def hangup
      @tropo2.write @call_event, @protocol::Message::Hangup.new
      read_event_queue
    end
    
    def say(string, type = :text)
      @tropo2.write @call_event, @protocol::Message::Say.new(type => string)
      read_event_queue unless get_method_name == 'say_nonblocking'
    end
    alias :say_nonblocking :say
    
    def transfer(to, options={})
      @tropo2.write @call_event, @protocol::Message::Transfer.new(to, options)
      read_event_queue
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
      @call_event = queue_item if queue_item.class == Punchblock::Call
      queue_item
    end
    
    private
    
    def get_method_name
      caller[0]=~/`(.*?)'/
      $1
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