require 'spec_helper'

describe "Rayo Ask matchers" do
  describe "an ask complete event" do
    subject do
      Punchblock::Rayo::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << reason
      end
    end

    describe "that's successful" do
      let :reason do
        Punchblock::Rayo::Component::Tropo::Ask::Complete::Success.new.tap do |success|
          success << '<utterance>blah</utterance>'
          success << '<interpretation>blah</interpretation>'
        end
      end

      it { should be_a_valid_successful_ask_event }
      it { should be_a_valid_successful_ask_event.with_utterance('blah') }
      it { should_not be_a_valid_successful_ask_event.with_utterance('woo') }
      it { should be_a_valid_successful_ask_event.with_interpretation('blah') }
      it { should_not be_a_valid_successful_ask_event.with_interpretation('woo') }
    end

    describe "that stopped" do
      let(:reason) { Punchblock::Rayo::Event::Complete::Stop.new }
      it { should be_a_valid_stopped_ask_event }
    end

    describe "that got no input" do
      let(:reason) { Punchblock::Rayo::Component::Tropo::Ask::Complete::NoInput.new }
      it { should be_a_valid_ask_noinput_event }
    end

    describe "that got no match" do
      let(:reason) { Punchblock::Rayo::Component::Tropo::Ask::Complete::NoMatch.new }
      it { should be_a_valid_ask_nomatch_event }
    end
  end
end
