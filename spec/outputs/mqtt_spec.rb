# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/mqtt"
require "logstash/codecs/json"
require "logstash/event"

describe LogStash::Outputs::MQTT do
  let(:sample_event) { LogStash::Event.new }
  settings = {
    "host" => "test.mosquitto.org",
    "topic" => "hello"
  }
  let(:output) { LogStash::Outputs::MQTT.new(settings) }

  before do
    output.register
#    def stubClient.publish()
#      puts "abcd3"
#    end
  end

  describe "receive message" do

    it "does not crash" do
      puts "0"

      stubClient = Object.new
      expect(MQTT::Client).to receive(:connect).with(
        :host => "test.mosquitto.org",
        :topic => "hello",
        :port => 8883
      )
# {
#        return stubClient
#      }
#      expect(stubClient).to receive(:publish2)

      puts "1"
      output.receive(sample_event)
      puts "testing"
      # expect(subject).to eq(nil)
    end
  end
end
