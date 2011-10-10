RSpec::Matchers.define :be_a_valid_conference_offhold_event do
  match_for_should do |event|
    match_type event, Punchblock::Component::Tropo::Conference::OffHold
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_speaking_event do
  chain :for_call_id do |call_id|
    @call_id = call_id
  end

  match_for_should do |event|
    match_type event, Punchblock::Component::Tropo::Conference::Speaking do
      @error = "The speaking call ID was not correct. Expected '#{@call_id}', got '#{event.speaking_call_id}'" if @call_id && event.speaking_call_id != @call_id
    end
  end

  failure_message_for_should do |actual|
    "The speaking event was not valid: #{@error}"
  end

  description do
    "be a valid speaking event".tap do |d|
      d << " with call ID '#{@call_id}'" if @call_id
    end
  end
end

RSpec::Matchers.define :be_a_valid_finished_speaking_event do
  chain :for_call_id do |call_id|
    @call_id = call_id
  end

  match_for_should do |event|
    match_type event, Punchblock::Component::Tropo::Conference::FinishedSpeaking do
      @error = "The finished-speaking call ID was not correct. Expected '#{@call_id}', got '#{event.speaking_call_id}'" if @call_id && event.speaking_call_id != @call_id
    end
  end

  failure_message_for_should do |actual|
    "The finished speaking event was not valid: #{@error}"
  end

  description do
    "be a valid finished speaking event".tap do |d|
      d << " with call ID '#{@call_id}'" if @call_id
    end
  end
end

RSpec::Matchers.define :be_a_valid_conference_complete_terminator_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Component::Tropo::Conference::Complete::Terminator
    end
  end

  failure_message_for_should do |actual|
    "The conference complete terminator event was not valid: #{@error}"
  end

  description do
    "be a valid conference complete terminator event"
  end
end
