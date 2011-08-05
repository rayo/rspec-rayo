RSpec::Matchers.define :be_a_valid_complete_recording_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.recording, Punchblock::Protocol::Rayo::Command::Record::Recording
    end
  end

  failure_message_for_should do |actual|
    "The recording event was not valid: #{@error}"
  end

  description do
    "be a valid complete recording event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_recording_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Event::Complete::Stop
      match_type event.recording, Punchblock::Protocol::Rayo::Command::Record::Recording
    end
  end

  failure_message_for_should do |actual|
    "The recording event was not valid: #{@error}"
  end

  description do
    "be a valid stopped recording event"
  end
end
