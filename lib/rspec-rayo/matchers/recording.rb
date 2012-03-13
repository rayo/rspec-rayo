RSpec::Matchers.define :be_a_valid_complete_recording_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.recording, Punchblock::Component::Record::Recording
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
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Event::Complete::Stop
      match_type event.recording, Punchblock::Component::Record::Recording
    end
  end

  failure_message_for_should do |actual|
    "The recording event was not valid: #{@error}"
  end

  description do
    "be a valid stopped recording event"
  end
end
