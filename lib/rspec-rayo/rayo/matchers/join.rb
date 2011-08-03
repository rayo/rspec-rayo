RSpec::Matchers.define :be_a_valid_joined_event do
  chain :with_other_call_id do |other_call_id|
    @other_call_id = other_call_id
  end

  chain :with_mixer_id do |mixer_id|
    @mixer_id = mixer_id
  end

  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Joined do
      @error = "The other call ID was not correct. Expected '#{@other_call_id}', got '#{event.other_call_id}'" if @other_call_id && event.other_call_id != @other_call_id
      @error = "The mixer ID was not correct. Expected '#{@mixer_id}', got '#{event.mixer_id}'" if @mixer_id && event.mixer_id != @mixer_id
    end
  end

  failure_message_for_should do |actual|
    "The joined event was not valid: #{@error}"
  end

  description do
    "be a valid joined event".tap do |d|
      d << " with other call ID '#{@other_call_id}'" if @other_call_id
      d << " with mixer ID '#{@mixer_id}'" if @mixer_id
    end
  end
end

RSpec::Matchers.define :be_a_valid_unjoined_event do
  chain :with_other_call_id do |other_call_id|
    @other_call_id = other_call_id
  end

  chain :with_mixer_id do |mixer_id|
    @mixer_id = mixer_id
  end

  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Unjoined do
      @error = "The other call ID was not correct. Expected '#{@other_call_id}', got '#{event.other_call_id}'" if @other_call_id && event.other_call_id != @other_call_id
      @error = "The mixer ID was not correct. Expected '#{@mixer_id}', got '#{event.mixer_id}'" if @mixer_id && event.mixer_id != @mixer_id
    end
  end

  failure_message_for_should do |actual|
    "The unjoined event was not valid: #{@error}"
  end

  description do
    "be a valid unjoined event".tap do |d|
      d << " with other call ID '#{@other_call_id}'" if @other_call_id
      d << " with mixer ID '#{@mixer_id}'" if @mixer_id
    end
  end
end

