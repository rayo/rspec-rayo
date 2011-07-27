require 'spec_helper'

describe "Rayo DTMF matchers" do
  describe "a DTMF event" do
    subject do
      Punchblock::Protocol::Rayo::Event::DTMF.new.tap do |dtmf_event|
        dtmf_event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
      end
    end

    it { should be_a_valid_dtmf_event }
  end
end
