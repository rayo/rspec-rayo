require 'spec_helper'

describe "Rayo Input matchers" do
  describe "an input complete event" do
    subject do
      Punchblock::Protocol::Rayo::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << reason
      end
    end

    describe "that's successful" do
      let :reason do
        Punchblock::Protocol::Rayo::Command::Input::Complete::Success.new.tap do |success|
          success << '<utterance>blah</utterance>'
          success << '<interpretation>blah</interpretation>'
        end
      end

      it { should be_a_valid_successful_input_event }
      it { should be_a_valid_successful_input_event.with_utterance('blah') }
      it { should_not be_a_valid_successful_input_event.with_utterance('woo') }
      it { should be_a_valid_successful_input_event.with_interpretation('blah') }
      it { should_not be_a_valid_successful_input_event.with_interpretation('woo') }
    end

    describe "that stopped" do
      let(:reason) { Punchblock::Protocol::Rayo::Event::Complete::Stop.new }
      it { should be_a_valid_stopped_input_event }
    end

    describe "that got no input" do
      let(:reason) { Punchblock::Protocol::Rayo::Command::Input::Complete::NoInput.new }
      it { should be_a_valid_input_noinput_event }
    end

    describe "that got no match" do
      let(:reason) { Punchblock::Protocol::Rayo::Command::Input::Complete::NoMatch.new }
      it { should be_a_valid_input_nomatch_event }
    end
  end
end
