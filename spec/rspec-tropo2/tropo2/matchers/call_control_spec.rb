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

  describe "an answered event" do
    subject do
      Punchblock::Protocol::Ozone::Event::Answered.new do |event|
        event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
      end
    end

    it { should be_a_valid_answered_event }
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

  describe "a ringing event" do
    subject do
      Punchblock::Protocol::Ozone::Event::Ringing.new do |event|
        event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
      end
    end

    it { should be_a_valid_ringing_event }
  end

  describe "a complete hangup event" do
    subject do
      Punchblock::Protocol::Ozone::Event::Complete.new.tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.command_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
        event << Punchblock::Protocol::Ozone::Event::Complete::Hangup.new
      end
    end

    it { should be_a_valid_complete_hangup_event }
  end

  describe "a redirect event" do
    subject do
      Punchblock::Protocol::Ozone::Event::End.new do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Ozone::OzoneNode.new('redirect')
      end
    end

    it { should be_a_valid_redirect_event }
  end

  describe "a reject event" do
    subject do
      Punchblock::Protocol::Ozone::Event::End.new do |end_event|
        end_event.call_id = "3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11"
        end_event << Punchblock::Protocol::Ozone::OzoneNode.new('reject')
      end
    end

    it { should be_a_valid_reject_event }
  end
end
