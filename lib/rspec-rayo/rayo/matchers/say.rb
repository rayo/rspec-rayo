RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Say::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid successful say event"
  end
end
