require 'spec_helper'

describe "Rayo Conference matchers" do
  describe "a conference event" do
    subject do
      Punchblock::Component::Tropo::Conference::OffHold.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
      end
    end

    it { should be_a_valid_conference_offhold_event }
  end

  describe "a speaking event" do
    subject do
      Punchblock::Component::Tropo::Conference::Speaking.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event.write_attr :'call-id', 'abc123'
      end
    end

    it { should be_a_valid_speaking_event }
    it { should be_a_valid_speaking_event.for_call_id('abc123') }
    it { should_not be_a_valid_speaking_event.for_call_id('123abc') }
  end

  describe "a finished-speaking event" do
    subject do
      Punchblock::Component::Tropo::Conference::FinishedSpeaking.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event.write_attr :'call-id', 'abc123'
      end
    end

    it { should be_a_valid_finished_speaking_event }
    it { should be_a_valid_finished_speaking_event.for_call_id('abc123') }
    it { should_not be_a_valid_finished_speaking_event.for_call_id('123abc') }
  end

  describe "a conference complete terminator event" do
    subject do
      Punchblock::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << Punchblock::Component::Tropo::Conference::Complete::Terminator.new
      end
    end

    it { should be_a_valid_conference_complete_terminator_event }
  end
end
