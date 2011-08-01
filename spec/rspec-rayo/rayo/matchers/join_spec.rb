require 'spec_helper'

describe "Rayo call control matchers" do
  describe "a joined event" do
    subject do
      Punchblock::Protocol::Rayo::Event::Joined.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
      end
    end

    it { should be_a_valid_joined_event }
  end

  describe "an unjoined event" do
    subject do
      Punchblock::Protocol::Rayo::Event::Unjoined.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
      end
    end

    it { should be_a_valid_unjoined_event }
  end
end
