RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Ozone::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Ozone::Command::Say::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid successful say event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_say_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Ozone::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Ozone::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid stopped say event"
  end
end