RSpec::Matchers.define :be_a_valid_output_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Rayo::Command::Output::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The output event was not valid: #{@error}"
  end

  description do
    "be a valid successful output event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_output_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Rayo::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The output event was not valid: #{@error}"
  end

  description do
    "be a valid stopped output event"
  end
end
