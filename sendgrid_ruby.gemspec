# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "sendgrid_ruby"
  spec.version       = SendgridRuby::VERSION
  spec.authors       = ["Wataru Sato"]
  spec.email         = ["awwa500@gmail.com"]
  spec.summary       = "Web API wrapper for SendGrid."
  spec.description   = "Web API wrapper for SendGrid."
  spec.homepage      = "https://github.com/sendgridjp/sendgrid-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "smtpapi"
  spec.add_dependency "rest-client"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "dotenv"
end
