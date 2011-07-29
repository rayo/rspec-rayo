RSpec::Matchers.define :be_a_valid_successful_input_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid successful input event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_input_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid stopped input event"
  end
end

RSpec::Matchers.define :be_a_valid_input_noinput_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::NoInput
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid noinput input event"
  end
end

RSpec::Matchers.define :be_a_valid_input_nomatch_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::NoMatch
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid nomatch input event"
  end
end
