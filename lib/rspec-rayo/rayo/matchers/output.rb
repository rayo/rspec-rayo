RSpec::Matchers.define :be_a_valid_output_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
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
