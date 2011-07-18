RSpec::Matchers.define :be_a_valid_conference_command do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Command::Conference::OffHold)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Command::Conference::OffHold'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end
