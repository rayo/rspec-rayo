require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RspecTropo2" do
  it "should validate an answer event" do
    answer_event = mock(Punchblock::Protocol::Ozone::Info)
    answer_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::Info)
    answer_event.stub!(:type).and_return(:answer)
    answer_event.stub!(:call_id).and_return("3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11")
    
    answer_event.should be_a_valid_answer_event
  end
  
  it "should validate a call event" do
    call_event = mock(Punchblock::Call)
    call_event.stub!(:class).and_return(Punchblock::Call)
    call_event.stub!(:call_id).and_return("8df3437f-285f-406e-9ba2-9d14af1b72c4@10.0.1.11")
    call_event.stub!(:to).and_return("sip:usera@10.0.1.11")
    call_event.stub!(:headers).and_return({ :content_type   => "application/sdp", 
                                            :contact        => "<sip:10.0.1.11:5060;transport=udp>", 
                                            :cseq           => "1 INVITE", 
                                            :max_forwards   => "70",
                                            :to             => "sip:usera@10.0.1.11", 
                                            :call_id        => "1bu9qwbcz2cum", 
                                            :content_length => "444", 
                                            :from           => "<sip:Tropo@10.6.69.201>;tag=1unfb1cousd2z", 
                                            :via            => "SIP/2.0/UDP 10.0.1.11:5060;branch=z9hG4bK10psx2ki47qe5;rport=5060", 
                                            :x_vdirect      => "true" })
    call_event.should be_a_valid_call_event
  end
  
  it "should validate a hangup event" do
    hangup_event = mock(Punchblock::Protocol::Ozone::End)
    hangup_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::End)
    hangup_event.stub!(:type).and_return(:hangup)
    hangup_event.stub!(:call_id).and_return("3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11")
    
    hangup_event.should be_a_valid_hangup_event
  end
  
  it "should validate a successful say event" do
    say_event = mock(Punchblock::Protocol::Ozone::Complete)
    say_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::Complete)
    say_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    say_event.stub!(:cmd_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    say_event.stub!(:attributes).and_return({ :reason => 'SUCCESS' })
    say_event.stub!(:xmlns).and_return('urn:xmpp:ozone:say:1')
    
    say_event.should be_a_valid_successful_say_event
  end
  
  it "should validate an ask event" do
    ask_event = mock(Punchblock::Protocol::Ozone::Complete)
    ask_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::Complete)
    ask_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    ask_event.stub!(:cmd_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    ask_event.stub!(:xmlns).and_return('urn:xmpp:ozone:ask:1')
    
    ask_event.should be_a_valid_ask_event
  end
end


