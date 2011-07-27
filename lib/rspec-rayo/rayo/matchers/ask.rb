RSpec::Matchers.define :be_a_valid_successful_ask_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Tropo::Ask::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid successful ask event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_ask_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid stopped ask event"
  end
end

RSpec::Matchers.define :be_a_valid_noinput_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Tropo::Ask::Complete::NoInput
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid noinput ask event"
  end
end

RSpec::Matchers.define :be_a_valid_nomatch_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Tropo::Ask::Complete::NoMatch
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid nomatch ask event"
  end
end
