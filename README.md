# Logstash MQTT Output Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

This plugin has been published to rubygems.org as [logstash-output-mqtt](https://rubygems.org/gems/logstash-output-mqtt/) gem.

## Installation to Logstash

In Logstash home directory: bin/logstash-plugin install logstash-output-mqtt

Ubuntu:
```
sudo /opt/logstash/bin/plugin install logstash-output-mqtt
```

## Usage

See [mqtt.rb](lib/logstash/outputs/mqtt.rb) file for plugin usage.

## License

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Developing

The plugin has been developed according to [How to write a Logstash output plugin](https://www.elastic.co/guide/en/logstash/current/_how_to_write_a_logstash_output_plugin.html) tutorial. Read it before contributing to this project.

### Build

To build and test, run [build.sh](build.sh) in Linux environment which has [Docker](https://www.docker.com) installed.

### Install locally to Logstash

To install the built plugin locally in the development environment:
```
sudo /opt/logstash/bin/plugin install logstash-output-mqtt-*.gem
```
