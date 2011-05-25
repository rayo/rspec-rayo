require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RspecTropo2" do
  it "should validate an answer event" do
    answer_event = mock(Punchblock::Protocol::Ozone::Message::Info)
    answer_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::Message::Info)
    answer_event.stub!(:type).and_return(:answer)
    answer_event.stub!(:call_id).and_return("3b7720bf-d5dc-4f4f-a837-d7338ec18b3a@10.0.1.11")
    
    answer_event.should be_a_valid_answer_event
  end
  
  it "should validate a call event" do
    call_event = mock(Punchblock::Call)
    call_event.stub!(:class).and_return(Punchblock::Call)
    call_event.stub!(:id).and_return("8df3437f-285f-406e-9ba2-9d14af1b72c4@10.0.1.11")
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
    pending()
    hangup_event = mock(Punchblock::Protocol::Ozone::Message::End)
    hangup_event.stub!(:class).and_return(Punchblock::Protocol::Ozone::Message::End)
  end
end


