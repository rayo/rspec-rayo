require 'countdownlatch'

module RSpecRayo
  class RayoDriver
    attr_reader :call_queue, :calls

    def initialize(options)
      @calls            = {}
      @call_queue       = Queue.new
      @queue_timeout    = options.delete(:queue_timeout) || 5
      @write_timeout    = options.delete(:write_timeout) || 5
      @threads          = []
      @connection_latch = CountDownLatch.new 1

      initialize_punchblock options
    end

    def wait_for_connection(timeout = nil)
      @connection_latch.wait timeout
    end

    def get_call
      Timeout::timeout(@queue_timeout) { @call_queue.pop }
    end

    def cleanup_calls
      @calls.each_pair do |call_id, call|
        call.hangup unless call.status == :finished
      end
      @calls = {}
    end

    def dial(options)
      new_call.tap do |call|
        dial = call.dial options
        call.call_id = dial.call_id
        @calls[call.call_id] = call
      end
    end

    private

    def new_call
      Call.new :client        => @pb_client,
               :read_timeout  => @queue_timeout,
               :write_timeout => @write_timeout
    end

    def initialize_punchblock(options)
      logger = Logger.new 'punchblock.log'

      def logger.trace(*args)
        debug *args
      end

      Punchblock.logger = logger

      connection = Punchblock::Connection::XMPP.new options

      @pb_client = Punchblock::Client.new  :connection => connection,
                                           :write_timeout => options[:write_timeout]

      @pb_client.register_event_handler do |event|
        if event.is_a?(Punchblock::Connection::Connected)
          logger.info "Connected!"
          @connection_latch.countdown!
          throw :pass
        end

        if call = @calls[event.call_id]
          @calls[event.call_id] << event
        else
          call = new_call
          @calls[event.call_id] = call
          @call_queue.push call
        end
      end

      Thread.new { @pb_client.run }
    end
  end
end
