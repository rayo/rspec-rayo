RSpec::Matchers.define :be_a_valid_conference_offhold_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Component::Tropo::Conference::OffHold, true
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
    basic_validation event, Punchblock::Component::Tropo::Conference::Speaking, true do
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
    basic_validation event, Punchblock::Component::Tropo::Conference::FinishedSpeaking, true do
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
