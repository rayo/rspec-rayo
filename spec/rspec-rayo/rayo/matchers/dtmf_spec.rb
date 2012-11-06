require 'spec_helper'

describe "Rayo DTMF matchers" do
  describe "a DTMF event" do
    subject do
      Punchblock::Event::DTMF.new.tap do |dtmf_event|
        dtmf_event.target_call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        dtmf_event.signal = 3
      end
    end

    it { should be_a_valid_dtmf_event }
    it { should be_a_valid_dtmf_event.with_signal('3') }
    it { should_not be_a_valid_dtmf_event.with_signal('5') }
  end
end
