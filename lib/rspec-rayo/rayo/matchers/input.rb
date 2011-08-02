RSpec::Matchers.define :be_a_valid_successful_input_event do
  chain :with_utterance do |utterance|
    @utterance = utterance
  end

  chain :with_interpretation do |interpretation|
    @interpretation = interpretation
  end

  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::Success
      @error = "The utterance was not correct. Expected '#{@utterance}', got '#{event.reason.utterance}'" if @utterance && event.reason.utterance != @utterance
      @error = "The interpretation was not correct. Expected '#{@interpretation}', got '#{event.reason.interpretation}'" if @interpretation && event.reason.interpretation != @interpretation
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid successful input event".tap do |d|
      d << " with utterance '#{@utterance}'" if @utterance
      d << " with interpretation '#{@interpretation}'" if @interpretation
    end
  end
end

RSpec::Matchers.define :be_a_valid_stopped_input_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid stopped input event"
  end
end

RSpec::Matchers.define :be_a_valid_input_noinput_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::NoInput
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid noinput input event"
  end
end

RSpec::Matchers.define :be_a_valid_input_nomatch_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Command::Input::Complete::NoMatch
    end
  end

  failure_message_for_should do |actual|
    "The input event was not valid: #{@error}"
  end

  description do
    "be a valid nomatch input event"
  end
end
