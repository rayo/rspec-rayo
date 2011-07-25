RSpec::Matchers.define :be_a_valid_complete_recording_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Ozone::Event::Complete, true do
      match_type event.recording, Punchblock::Protocol::Ozone::Command::Record::Recording
    end
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid complete recording event"
  end
end
