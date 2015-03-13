#!/usr/bin/env ruby
# 金盾防火墙报文抓取

require 'optparse'
require 'mechanize'

def parse(size, filename, host)
  size = size.nil? ? '500' : size
  host = host.nil? ? 'your firewall address' : host
  filename = filename.nil? ? 'capture' : filename

  agent = Mechanize.new

  # Seting Cookie
  cookie = Mechanize::Cookie.new("sid", "your cookie")
  cookie.domain = host
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  # 设置报文数目
  agent.post("http://#{host}:28099/cgi-bin/service_capture.cgi",
             "param_capture_count" => size,
             "param_submit_type" => "submit")

  agent.post("http://#{host}:28099/cgi-bin/service_capture.cgi",
             "param_submit_type" => "download").save_as "#{filename}.cap"
end

options = {}

OptionParser.new do |opts|
  opts.banner = 'Firewall Pack output Tool.'

  opts.on('-s SIZE', '--size Size', 'Set pack size') do |value|
    options[:size] = value
  end

  opts.on('-f filename', '--filename File Name',
          'Set output file name') do |value|
    options[:filename] = value
  end

  opts.on('-h host', '--host Host', 'Set Firewall host address') do |value|
    options[:host] = value
  end
end.parse!

unless options.empty?
  puts "File Saved: " + parse(options[:size],
                              options[:filename],
                              options[:host])
else
  puts "Saved default 500 Size Message: " + parse('500',
                                                  'capture',
                                                  'your firewall address')
  puts "More see help: ruby c.rb --help"
end
