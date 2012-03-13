require 'spec_helper'

describe "Rayo call control matchers" do
  describe "a joined event" do
    subject do
      Punchblock::Event::Joined.new(:other_call_id => 'foo', :mixer_name => 'foo1').tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
      end
    end

    it { should be_a_valid_joined_event }
    it { should be_a_valid_joined_event.with_other_call_id('foo') }
    it { should_not be_a_valid_joined_event.with_other_call_id('bar') }
    it { should be_a_valid_joined_event.with_mixer_name('foo1') }
    it { should_not be_a_valid_joined_event.with_mixer_name('bar1') }
  end

  describe "an unjoined event" do
    subject do
      Punchblock::Event::Unjoined.new(:other_call_id => 'foo', :mixer_name => 'foo1').tap do |event|
        event.call_id = '5d6fe904-103d-4551-bd47-cf212c37b8c7'
        event.component_id = '6d5bf745-8fa9-4e78-be18-6e6a48393f13'
      end
    end

    it { should be_a_valid_unjoined_event }
    it { should be_a_valid_unjoined_event.with_other_call_id('foo') }
    it { should_not be_a_valid_unjoined_event.with_other_call_id('bar') }
    it { should be_a_valid_unjoined_event.with_mixer_name('foo1') }
    it { should_not be_a_valid_unjoined_event.with_mixer_name('bar1') }
  end
end
