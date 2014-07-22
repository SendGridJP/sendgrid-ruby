# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require "net/https"
require "rest-client"

module SendgridRuby
  class Sendgrid

    attr_accessor :debug_output

    def initialize(username, password, options={"turn_off_ssl_verification" => false})
      @username = username
      @password = password
      @options = options
      @debug_output = false
    end

    def send(email)
      form              = email.to_web_format
      form['api_user']  = @username
      form['api_key']   = @password

      RestClient.log = $stderr if @debug_output

      headers          = Hash.new
      headers[:content_type] = :json
      response = RestClient.post 'https://api.sendgrid.com/api/mail.send.json', form, :content_type => :json, "User-Agent" => "sendgrid/#{SendgridRuby::VERSION};ruby"

      JSON.parse(response.body)
    end

  end
end
