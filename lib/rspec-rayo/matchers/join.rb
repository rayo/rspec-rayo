RSpec::Matchers.define :be_a_valid_joined_event do
  chain :with_other_call_id do |other_call_id|
    @other_call_id = other_call_id
  end

  chain :with_mixer_name do |mixer_name|
    @mixer_name = mixer_name
  end

  match_for_should do |event|
    match_type event, Punchblock::Event::Joined do
      @error = "The other call ID was not correct. Expected '#{@other_call_id}', got '#{event.other_call_id}'" if @other_call_id && event.other_call_id != @other_call_id
      @error = "The mixer ID was not correct. Expected '#{@mixer_name}', got '#{event.mixer_name}'" if @mixer_name && event.mixer_name != @mixer_name
    end
  end

  failure_message_for_should do |actual|
    "The joined event was not valid: #{@error}"
  end

  description do
    "be a valid joined event".tap do |d|
      d << " with other call ID '#{@other_call_id}'" if @other_call_id
      d << " with mixer ID '#{@mixer_name}'" if @mixer_name
    end
  end
end

RSpec::Matchers.define :be_a_valid_unjoined_event do
  chain :with_other_call_id do |other_call_id|
    @other_call_id = other_call_id
  end

  chain :with_mixer_name do |mixer_name|
    @mixer_name = mixer_name
  end

  match_for_should do |event|
    match_type event, Punchblock::Event::Unjoined do
      @error = "The other call ID was not correct. Expected '#{@other_call_id}', got '#{event.other_call_id}'" if @other_call_id && event.other_call_id != @other_call_id
      @error = "The mixer ID was not correct. Expected '#{@mixer_name}', got '#{event.mixer_name}'" if @mixer_name && event.mixer_name != @mixer_name
    end
  end

  failure_message_for_should do |actual|
    "The unjoined event was not valid: #{@error}"
  end

  description do
    "be a valid unjoined event".tap do |d|
      d << " with other call ID '#{@other_call_id}'" if @other_call_id
      d << " with mixer ID '#{@mixer_name}'" if @mixer_name
    end
  end
end

