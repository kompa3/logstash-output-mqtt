# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# This is Logstash output plugin for the http://mqtt.org/[MQTT] protocol.
#
# Features:
#
# * Publish messages to a topic
# * TSL/SSL connection to MQTT server (optional)
# * Message publishing to a topic
# * QoS levels 0 and 1 (note that QoS 2 is not currently supported due to https://github.com/njh/ruby-mqtt[ruby-mqtt] library limitations)
# * Automatic reconnect to server
#
# Example publishing to test.mosquitto.org:
# [source,ruby]
# ----------------------------------
# output {
#   mqtt {
#     host => "test.mosquitto.org"
#     port => 8883
#     topic => "hello"
#   }
# }
# ----------------------------------
#
# Example publishing to https://aws.amazon.com/iot/[AWS IoT]:
# [source,ruby]
# ----------------------------------
# output {
#   mqtt {
#     host => "somehostname.iot.someregion.amazonaws.com"
#     port => 8883
#     topic => "hello"
#     clientId => "the client ID you will use to connect to AWS IoT"
#     ssl => true
#     cert_file => "certificate.pem.crt"  # Client certificate file
#     key_file => "private.pem.key"       # Private key file associated with the client certificate
#     ca_file => "root-CA.crt"            # the root CA certificate
#   }
# }
# ----------------------------------
#
# Note that you will obtain the above configuration items when connecting a device in AWS IoT service.
# The root CA certificate is also available from Symantec https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem[here].

class LogStash::Outputs::MQTT < LogStash::Outputs::Base

  config_name "mqtt"

  # The default codec for this plugin is JSON. You can override this to suit your particular needs however.
  default :codec, "json"

  # Host name

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::MQTT
