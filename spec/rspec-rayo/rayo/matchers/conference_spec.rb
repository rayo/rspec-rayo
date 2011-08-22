require 'spec_helper'

describe "Rayo Conference matchers" do
  it "should validate a conference event" do
    pending
    conference_event = mock(Punchblock::Event)
    conference_event.stub!(:is_a?).with(Punchblock::Event).and_return true
    conference_event.stub!(:call_id).and_return('5d6fe904-103d-4551-bd47-cf212c37b8c7')
    conference_event.stub!(:component_id).and_return('6d5bf745-8fa9-4e78-be18-6e6a48393f13')
    conference_event.stub!(:namespace_href).and_return('urn:xmpp:ozone:ext:1')
    conference_event.stub_chain(:reason, :name).and_return(:hangup)

    conference_event.should be_a_valid_conference_event
  end
end
