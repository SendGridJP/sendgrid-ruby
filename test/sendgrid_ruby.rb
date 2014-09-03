# -*- encoding: utf-8 -*-
require "test/unit"
require "dotenv"
require "./lib/sendgrid_ruby"
require "./lib/sendgrid_ruby/version"
require "./lib/sendgrid_ruby/email"

class SendgridRubyTest < Test::Unit::TestCase

  def setup
    config = Dotenv.load
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @from = ENV["FROM"]
    @tos = ENV["TOS"].split(',') if ENV["TOS"] != nil
  end

  def test_version
    assert_equal("0.0.4", SendgridRuby::VERSION)
  end

  def test_initialize
    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    assert_equal(SendgridRuby::Sendgrid, sendgrid.class)
  end

  def test_send_bad_credential
    email = SendgridRuby::Email.new
    email.set_from('bar@foo.com').
      set_subject('test_send_bad_credential subject').
      set_text('foobar text').
      add_to('foo@bar.com')

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send
    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send subject').
      set_text('foobar text').
      add_to(@to)

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send_with_attachment_text
    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send_with_attachment_text subject').
      set_text('foobar text').
      add_to(@to).
      add_attachment('./test/file1.txt')

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send_with_attachment_binary
    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send_with_attachment subject').
      set_text('foobar text').
      add_to(@to).
      add_attachment('./test/gif.gif')

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send_with_attachment_missing_extension
    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send_with_attachment_missing_extension subject').
      set_text('foobar text').
      add_to(@to).
      add_attachment('./test/gif')

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send_with_ssl_option_false
    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send_with_ssl_option_false subject').
      set_text('foobar text').
      add_to(@to)

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass", {"turn_off_ssl_verification" => true})
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end
  end

  def test_send_unicode
    email = SendgridRuby::Email.new
    email.add_to(@to)
    .set_from(@from)
    .set_from_name("送信者名")
    .set_subject("[sendgrid-ruby-example] フクロウのお名前はfullnameさん")
    .set_text("familyname さんは何をしていますか？\r\n 彼はplaceにいます。")
    .set_html("<strong> familyname さんは何をしていますか？</strong><br />彼はplaceにいます。")
    .add_substitution("fullname", ["田中 太郎", "佐藤 次郎", "鈴木 三郎"])
    .add_substitution("familyname", ["田中", "佐藤", "鈴木"])
    .add_substitution("place", ["office", "home", "office"])
    .add_section('office', '中野')
    .add_section('home', '目黒')
    .add_category('カテゴリ1')
    .add_header('X-Sent-Using', 'SendgridRuby-API')
    .add_attachment('./test/gif.gif', 'owl.gif')

    sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
    sendgrid.debug_output = true
    assert_raise RestClient::BadRequest do
      sendgrid.send(email)
    end

  end

  def test_send_if_avairable

    if @from == nil || @tos == nil
      return
    end

    email = SendgridRuby::Email.new
    email.set_from(@from).
      set_subject('test_send subject').
      set_text('foobar text').
      add_to(@tos[0])

    sendgrid = SendgridRuby::Sendgrid.new(@username, @password)
    sendgrid.debug_output = true
    sendgrid.send(email)

  end

end
