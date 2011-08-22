RSpec::Matchers.define :be_a_valid_transfer_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Transfer::Complete::Success
    end
  end

  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "be a valid transfer event"
  end
end

RSpec::Matchers.define :be_a_valid_transfer_timeout_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Transfer::Complete::Timeout
    end
  end

  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "be a valid transfer timeout event"
  end
end
