# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/mqtt"
require "logstash/codecs/json"
require "logstash/event"
require "time"
require "json"

describe LogStash::Outputs::MQTT do
  # Define a sample event and its JSON encoded form
  datestring = "2016-01-01"
  tstamp = Time.parse(datestring)
  tstamp_utc = tstamp.utc.iso8601(3)
  let(:sample_event) { LogStash::Event.new("message" => "test message", "@timestamp" => datestring) }
  encoded_event = "{\"message\":\"test message\",\"@version\":\"1\",\"@timestamp\":\"" + tstamp_utc + "\"}"

  settings = {
    "host" => "test.mosquitto.org",
    "topic" => "hello"
  }
  let(:output) { LogStash::Outputs::MQTT.new(settings) }
  let(:stub_client) { instance_double(MQTT::Client) }

  before do
    output.register
  end

  describe "receive message" do
    it "connects and publishes with correct arguments" do
      expect(MQTT::Client).to receive(:connect).with(
        :host => "test.mosquitto.org",
        :port => 8883
      ).and_return(stub_client)
      expect(stub_client).to receive(:publish).with("hello", encoded_event, false, 0)
      output.receive(sample_event)
    end
  end

  describe "multi_receive" do
    it "connects once and publishes all messages" do
      expect(MQTT::Client).to receive(:connect).once.with(
        :host => "test.mosquitto.org",
        :port => 8883
      ).and_return(stub_client)
      expect(stub_client).to receive(:publish).exactly(3).times.with("hello", encoded_event, false, 0)
      three_events = [sample_event, sample_event, sample_event]
      output.multi_receive(three_events)
    end
  end
end

describe "Test subtopic:" do
  # Define a sample event and its JSON encoded form
  datestring = "2016-01-01"
  tstamp = Time.parse(datestring)
  tstamp_utc = tstamp.utc.iso8601(3)
  let(:sample_event) { LogStash::Event.new("message" => "test message", "@timestamp" => datestring, "subtopic" => "mysubtopic") }
  encoded_event = "{\"@version\":\"1\",\"@timestamp\":\"" + tstamp_utc + "\",\"message\":\"test message\",\"subtopic\":\"mysubtopic\"}"

  settings = {
    "host" => "test.mosquitto.org",
    "topic" => "hello/%{subtopic}"
  }
  let(:output) { LogStash::Outputs::MQTT.new(settings) }
  let(:stub_client) { instance_double(MQTT::Client) }

  before do
    output.register
  end

  describe "receive message on a subtopic based on a field of an event" do
    it "connects and publishes" do
      expect(MQTT::Client).to receive(:connect).with(
        :host => "test.mosquitto.org",
        :port => 8883
      ).and_return(stub_client)
      expect(stub_client).to receive(:publish).with("hello/mysubtopic", encoded_event, false, 0)
      output.receive(sample_event)
    end
  end

end
