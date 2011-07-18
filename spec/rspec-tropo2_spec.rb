require 'spec_helper'

describe "RspecTropo2" do
  it "should validate an answer event" do
    answer_event = mock(Punchblock::Protocol::Ozone::Event)
    answer_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Answered).and_return true
    answer_event.stub!(:reason).and_return(:answer)
    answer_event.stub!(:call_id).and_return("3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11")

    answer_event.should be_a_valid_answered_event
  end

  it "should validate a call event" do
    call_event = mock(Punchblock::Call)
    call_event.stub!(:is_a?).with(Punchblock::Call).and_return true
    call_event.stub!(:call_id).and_return("8df3437f-285f-406e-9ba2-9d14af1b72c4@10.0.1.11")
    call_event.stub!(:to).and_return("sip:usera@10.0.1.11")
    call_event.stub!(:headers).and_return :content_type   => "application/sdp",
                                          :contact        => "<sip:10.0.1.11:5060;transport=udp>",
                                          :cseq           => "1 INVITE",
                                          :max_forwards   => "70",
                                          :to             => "sip:usera@10.0.1.11",
                                          :call_id        => "1bu9qwbcz2cum",
                                          :content_length => "444",
                                          :from           => "<sip:Tropo@10.6.69.201>;tag=1unfb1cousd2z",
                                          :via            => "SIP/2.0/UDP 10.0.1.11:5060;branch=z9hG4bK10psx2ki47qe5;rport=5060",
                                          :x_vdirect      => "true"
    call_event.should be_a_valid_call_event
  end

  it "should validate a hangup event" do
    hangup_event = mock(Punchblock::Protocol::Ozone::Event)
    hangup_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::End).and_return true
    hangup_event.stub!(:reason).and_return(:hangup)
    hangup_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:1')
    hangup_event.stub!(:call_id).and_return("3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11")

    hangup_event.should be_a_valid_hangup_event
  end

  it "should validate a successful say event" do
    say_event = mock(Punchblock::Protocol::Ozone::Event)
    say_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    say_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    say_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    say_event.stub_chain(:reason, :name).and_return(:success)
    say_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:say:complete:1')

    say_event.should be_a_valid_say_event
  end

  it "should validate a stopped say event" do
    say_event = mock(Punchblock::Protocol::Ozone::Event)
    say_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event).and_return true
    say_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    say_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    say_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:say:1')
    say_event.stub_chain(:reason, :name).and_return(:stop)

    say_event.should be_a_valid_stopped_say_event
  end

  it "should validate an ask event" do
    ask_event = mock(Punchblock::Protocol::Ozone::Event)
    ask_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    ask_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    ask_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    ask_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    ask_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:ask:complete:1')

    ask_event.should be_a_valid_ask_event
  end

  it "should validate a stopped ask event" do
    ask_event = mock(Punchblock::Protocol::Ozone::Event)
    ask_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    ask_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    ask_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    ask_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ask:1')
    ask_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:ext:complete:1')
    ask_event.stub_chain(:reason, :name).and_return(:hangup)

    ask_event.should be_a_valid_stopped_ask_event
  end

  it "should validate a NOINPUT event" do
    noinput_event = mock(Punchblock::Protocol::Ozone::Event)
    noinput_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    noinput_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    noinput_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    noinput_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    noinput_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:ask:complete:1')
    noinput_event.stub_chain(:reason, :name).and_return(:noinput)

    noinput_event.should be_a_valid_noinput_event
  end

  it "should validate a NOMATCH event" do
    nomatch_event = mock(Punchblock::Protocol::Ozone::Event)
    nomatch_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    nomatch_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    nomatch_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    nomatch_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    nomatch_event.stub_chain(:reason, :is_a?).with(Punchblock::Protocol::Ozone::Command::Ask::Complete::NoMatch).and_return true
    nomatch_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:ask:complete:1')
    nomatch_event.stub_chain(:reason, :name).and_return(:nomatch)

    nomatch_event.should be_a_valid_nomatch_event
  end

  it "should validate a conference event" do
    pending
    conference_event = mock(Punchblock::Protocol::Ozone::Event)
    conference_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event).and_return true
    conference_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    conference_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    conference_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    conference_event.stub_chain(:reason, :name).and_return(:hangup)

    conference_event.should be_a_valid_conference_event
  end

  it "should validate a transfer event" do
    transfer_event = mock(Punchblock::Protocol::Ozone::Event)
    transfer_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    transfer_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    transfer_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    transfer_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    transfer_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:transfer:complete:1')
    transfer_event.stub_chain(:reason, :name).and_return(:success)

    transfer_event.should be_a_valid_transfer_event
  end

  it "should validate a transfer timeout event" do
    transfer_event = mock(Punchblock::Protocol::Ozone::Event)
    transfer_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::Complete).and_return true
    transfer_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    transfer_event.stub!(:command_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    transfer_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    transfer_event.stub_chain(:reason, :namespace_href).and_return('urn:xmpp:ozone:transfer:complete:1')
    transfer_event.stub_chain(:reason, :name).and_return(:timeout)

    transfer_event.should be_a_valid_transfer_timeout_event
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

  it "should validate a DTMF event" do
    ring_event = mock(Punchblock::Protocol::Ozone::Event::DTMF)
    ring_event.stub!(:is_a?).with(Punchblock::Protocol::Ozone::Event::DTMF).and_return true
    ring_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    ring_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:1')

    ring_event.should be_a_valid_dtmf_event
  end
end
