RSpec::Matchers.define :be_a_valid_dtmf_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::DTMF
  end

  failure_message_for_should do |actual|
    "The DTMF event was not valid: #{@error}"
  end

  description do
    "be a valid DTMF event"
  end
end
