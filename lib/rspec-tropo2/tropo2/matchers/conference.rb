RSpec::Matchers.define :be_a_valid_conference_command do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Ozone::Command::Conference::OffHold, true
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end
