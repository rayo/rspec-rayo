RSpec::Matchers.define :be_a_valid_dtmf_event do
  chain :with_signal do |signal|
    @signal = signal
  end

  match_for_should do |event|
    match_type event, Punchblock::Event::DTMF do
      @error = "The signal was not correct. Expected '#{@signal}', got '#{event.signal}'" if @signal && event.signal != @signal
    end
  end

  failure_message_for_should do |actual|
    "The DTMF event was not valid: #{@error}"
  end

  description do
    "be a valid DTMF event".tap do |d|
      d << " with signal '#{@signal}'" if @signal
    end
  end
end