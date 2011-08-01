RSpec::Matchers.define :be_a_valid_joined_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Joined
  end

  failure_message_for_should do |actual|
    "The joined event was not valid: #{@error}"
  end

  description do
    "be a valid joined event"
  end
end

RSpec::Matchers.define :be_a_valid_unjoined_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Unjoined
  end

  failure_message_for_should do |actual|
    "The unjoined event was not valid: #{@error}"
  end

  description do
    "be a valid unjoined event"
  end
end

