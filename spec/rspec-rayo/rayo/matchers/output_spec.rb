require 'spec_helper'

describe "Rayo Output matchers" do
  describe "a output complete event" do
    subject do
      Punchblock::Rayo::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << reason
      end
    end

    describe "that's successful" do
      let(:reason) { Punchblock::Rayo::Command::Output::Complete::Success.new }
      it { should be_a_valid_output_event }
    end

    describe "that stopped" do
      let(:reason) { Punchblock::Rayo::Event::Complete::Stop.new }
      it { should be_a_valid_stopped_output_event }
    end
  end
end
