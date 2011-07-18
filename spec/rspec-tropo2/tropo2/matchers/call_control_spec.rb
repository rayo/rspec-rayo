require 'spec_helper'

describe "Tropo2 call control matchers" do
  describe "an answered event" do
    subject do
      Punchblock::Protocol::Ozone::Event::Answered.new.tap do |answered_event|
        answered_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
      end
    end

    it { should be_a_valid_answered_event }
  end

  describe "a call event" do
    let(:headers) do
      {
        :content_type   => "application/sdp",
        :contact        => "<sip:10.0.1.11:5060;transport=udp>",
        :cseq           => "1 INVITE",
        :max_forwards   => "70",
        :to             => "sip:usera@10.0.1.11",
        :call_id        => "1bu9qwbcz2cum",
        :content_length => "444",
        :from           => "<sip:Tropo@10.6.69.201>;tag=1unfb1cousd2z",
        :via            => "SIP/2.0/UDP 10.0.1.11:5060;branch=z9hG4bK10psx2ki47qe5;rport=5060",
        :x_vdirect      => "true"
      }
    end

    subject do
      Punchblock::Call.new("8df3437f-285f-406e-9ba2-9d14af1b72c4@10.0.1.11", "sip:usera@10.0.1.11", headers)
    end

    it { should be_a_valid_call_event }
  end

  describe "a hangup event" do
    subject do
      Punchblock::Protocol::Ozone::Event::End.new do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Ozone::OzoneNode.new('hangup')
      end
    end

    it { should be_a_valid_hangup_event }
  end

  it "should validate a ring event" do
    pending
    ring_event = mock(Punchblock::Protocol::Ozone::Event)
    ring_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event).and_return true
    ring_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    ring_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:info:1')
    ring_event.stub!(:reason).and_return(:ring)

    ring_event.should be_a_valid_ring_event
  end
end
