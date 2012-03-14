%w{
  punchblock

  rspec-rayo/version
  rspec-rayo/driver
  rspec-rayo/call
  rspec-rayo/matchers
}.each { |lib| require lib }

module Punchblock
  class CommandNode
    def await_completion(timeout = 60)
      tap do |c|
        c.response timeout
      end
    end
  end

  module Component
    class ComponentNode
      attr_accessor :event_queue

      def initialize(*args)
        super
        @event_queue = Queue.new
        register_event_handler do |event|
          @event_queue << event
        end
      end

      def next_event(timeout = nil)
        Timeout::timeout(timeout || $config['rayo_queue']['connection_timeout']) { event_queue.pop }
      end
    end
  end
end
