RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
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
