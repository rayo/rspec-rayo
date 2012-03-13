RSpec::Matchers.define :be_a_valid_output_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Component::Output::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The output event was not valid: #{@error}"
  end

  description do
    "be a valid successful output event"
  end
end
