require 'spec_helper'

describe "Rayo call control matchers" do
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
      Punchblock::Protocol::Rayo::Event::Offer.new.tap do |offer|
        offer.call_id = "8df3437f-285f-406e-9ba2-9d14af1b72c4"
        offer.to = "sip:usera@10.0.1.11"
        offer.headers = headers
      end
    end

    it { should be_a_valid_offer_event }
  end

  describe "an answered event" do
    subject do
      Punchblock::Protocol::Rayo::Event::Answered.new.tap do |event|
        event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
      end
    end

    it { should be_a_valid_answered_event }
  end

  describe "a hangup event" do
    subject do
      Punchblock::Protocol::Rayo::Event::End.new.tap do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Rayo::RayoNode.new('hangup')
      end
    end

    it { should be_a_valid_hangup_event }
  end

  describe "a ringing event" do
    subject do
      Punchblock::Protocol::Rayo::Event::Ringing.new.tap do |event|
        event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
      end
    end

    it { should be_a_valid_ringing_event }
  end

  describe "a redirect event" do
    subject do
      Punchblock::Protocol::Rayo::Event::End.new.tap do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Rayo::RayoNode.new('redirect')
      end
    end

    it { should be_a_valid_redirect_event }
  end

  describe "a reject event" do
    subject do
      Punchblock::Protocol::Rayo::Event::End.new.tap do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Rayo::RayoNode.new('reject')
      end
    end

    it { should be_a_valid_reject_event }
  end
end
