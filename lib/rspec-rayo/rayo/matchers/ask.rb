RSpec::Matchers.define :be_a_valid_successful_ask_event do
  chain :with_utterance do |utterance|
    @utterance = utterance
  end

  chain :with_interpretation do |interpretation|
    @interpretation = interpretation
  end

  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Ask::Complete::Success
      @error = "The utterance was not correct. Expected '#{@utterance}', got '#{event.reason.utterance}'" if @utterance && event.reason.utterance != @utterance
      @error = "The interpretation was not correct. Expected '#{@interpretation}', got '#{event.reason.interpretation}'" if @interpretation && event.reason.interpretation != @interpretation
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid successful ask event".tap do |d|
      d << " with utterance '#{@utterance}'" if @utterance
      d << " with interpretation '#{@interpretation}'" if @interpretation
    end
  end
end

RSpec::Matchers.define :be_a_valid_stopped_ask_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid stopped ask event"
  end
end

RSpec::Matchers.define :be_a_valid_ask_noinput_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Ask::Complete::NoInput
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid noinput ask event"
  end
end

RSpec::Matchers.define :be_a_valid_ask_nomatch_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Event::Complete, true do
      match_type event.reason, Punchblock::Component::Tropo::Ask::Complete::NoMatch
    end
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid nomatch ask event"
  end
end
