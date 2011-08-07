require 'spec_helper'

describe "Rayo call control matchers" do
  describe "a complete hangup event" do
    subject do
      Punchblock::Rayo::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << Punchblock::Rayo::Event::Complete::Hangup.new
      end
    end

    it { should be_a_valid_complete_hangup_event }
  end

  describe "a complete error event" do
    subject do
      Punchblock::Rayo::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        reason = Punchblock::Rayo::Event::Complete::Error.new
        reason << "It's all broke"
        event << reason
      end
    end

    it { should be_a_valid_complete_error_event.with_message("It's all broke") }
    it { should_not be_a_valid_complete_error_event.with_message("It's all working") }
  end
end
