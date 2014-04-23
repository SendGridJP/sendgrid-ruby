# -*- encoding: utf-8 -*-
require "test/unit"
require "./lib/sendgrid_ruby"
require "./lib/sendgrid_ruby/email"

class EmailTest < Test::Unit::TestCase

  def test_initialize
    email = SendgridRuby::Email.new
    assert_equal(SendgridRuby::Email, email.class)
  end

  def test_add_to
    email = SendgridRuby::Email.new

    email.add_to('p1@mailinator.com')
    assert_equal(['p1@mailinator.com'], email.get_tos)

    email.add_to('p2@mailinator.com')
    assert_equal(['p1@mailinator.com', 'p2@mailinator.com'], email.get_tos)
  end

  def test_remove_to
    email = SendgridRuby::Email.new

    email.add_to('p1@mailinator.com')
    assert_equal(1, email.get_tos.length)
    email.remove_to('p1@mailinator.com')
    assert_equal(0, email.get_tos.length)
  end

  def test_add_to_with_name
    email = SendgridRuby::Email.new

    email.add_to('p1@mailinator.com', 'Person One')
    assert_equal(['Person One <p1@mailinator.com>'], email.get_tos)

    email.add_to('p2@mailinator.com')
    assert_equal(['Person One <p1@mailinator.com>', 'p2@mailinator.com'], email.get_tos)
  end

  def test_set_to
    email = SendgridRuby::Email.new
    email.set_tos(['p1@mailinator.com'])
    assert_equal(['p1@mailinator.com'], email.get_tos)
  end

  def test_set_tos
    email = SendgridRuby::Email.new
    email.set_tos(['p1@mailinator.com'])
    assert_equal(['p1@mailinator.com'], email.get_tos)
  end

  def test_set_from
    email = SendgridRuby::Email.new

    email.set_from("foo@bar.com")
    email.set_from_name("John Doe")

    assert_equal("foo@bar.com", email.get_from)
    assert_equal({"foo@bar.com" => "John Doe"}, email.get_from(true))
  end

  def test_set_from_name
    email = SendgridRuby::Email.new

    assert_equal(nil, email.get_from_name)
    email.set_from_name("Swift")
    assert_equal("Swift", email.get_from_name)
  end

  def test_set_reply_to
    email = SendgridRuby::Email.new

    assert_equal(nil, email.get_reply_to)
    email.set_reply_to("swift@sendgrid.com")
    assert_equal("swift@sendgrid.com", email.get_reply_to)
  end

  # def test_set_cc
  #   email = SendgridRuby::Email.new

  #   email.set_cc('p1@mailinator.com')
  #   email.set_cc('p2@mailinator.com')

  #   assert_equal(1, email.get_ccs.length)
  #   cc_list = email.get_ccs
  #   assert_equal('p2@mailinator.com', cc_list[0])
  # end

  # def test_set_ccs
  #   email = SendgridRuby::Email.new

  #   email.set_ccs(['raz@mailinator.com', 'ber@mailinator.com'])

  #   assert_equal(2, email.get_ccs.length)

  #   cc_list = email.get_ccs

  #   assert_equal('raz@mailinator.com', cc_list[0])
  #   assert_equal('ber@mailinator.com', cc_list[1])
  # end

  # def test_add_cc
  #   email = SendgridRuby::Email.new

  #   email.add_cc('foo')
  #   email.add_cc('raz')

  #   assert_equal(2, email.get_ccs.length)

  #   cc_list = email.get_ccs

  #   assert_equal('foo', cc_list[0])
  #   assert_equal('raz', cc_list[1])

  #   # removeTo removes all occurences of data
  #   email.remove_cc('raz')

  #   assert_equal(1, email.get_ccs.length)

  #   cc_list = email.get_ccs

  #   assert_equal('foo', cc_list[0])
  # end

  # def test_set_bcc
  #   email = SendgridRuby::Email.new

  #   email.set_bcc('bar')
  #   email.set_bcc('foo')
  #   assert_equal(1, email.get_bccs.length)

  #   bcc_list = email.get_bccs
  #   assert_equal('foo', bcc_list[0])
  # end

  # def test_set_bccs
  #   email = SendgridRuby::Email.new

  #   email.set_bccs(['raz', 'ber'])
  #   assert_equal(2, email.get_bccs.length)

  #   bcc_list = email.get_bccs
  #   assert_equal('raz', bcc_list[0])
  #   assert_equal('ber', bcc_list[1])
  # end

  # def test_add_bcc
  #   email = SendgridRuby::Email.new

  #   email.add_bcc('foo')
  #   email.add_bcc('raz')
  #   assert_equal(2, email.get_bccs.length)

  #   bcc_list = email.get_bccs
  #   assert_equal('foo', bcc_list[0])
  #   assert_equal('raz', bcc_list[1])

  #   email.remove_bcc('raz')

  #   assert_equal(1, email.get_bccs.length)
  #   bcc_list = email.get_bccs
  #   assert_equal('foo', bcc_list[0])
  # end

  def test_set_subject
    email = SendgridRuby::Email.new

    email.set_subject("Test Subject")
    assert_equal("Test Subject", email.get_subject)
  end

  def test_set_text
    email = SendgridRuby::Email.new

    text = "sample plain text"
    email.set_text(text)
    assert_equal(text, email.get_text)
  end

  def test_set_html
    email = SendgridRuby::Email.new

    html = "<p style = 'color:red;'>Sample HTML text</p>"
    email.set_html(html)
    assert_equal(html, email.get_html)
  end

  def test_set_attachments
    email = SendgridRuby::Email.new

    attachments =
    [
      "test/file1.txt",
      "test/file2.txt",
      "test/file3.txt"
    ]

    email.set_attachments(attachments)
    msg_attachments = email.get_attachments
    assert_equal(attachments.length, msg_attachments.length)

    for i in 0...attachments.length
      assert_equal(attachments[i], msg_attachments[i]['file'])
    end
  end

  def test_set_attachments_with_custom_filename
    email = SendgridRuby::Email.new

    attachments =
    {
      "customName.txt" =>   "test/file1.txt",
      'another_name_|.txt' => "test/file2.txt",
      'custom_name_2.zip' => "test/file3.txt"
    }

    email.set_attachments(attachments)
    msg_attachments = email.get_attachments

    assert_equal('customName.txt', msg_attachments[0]['custom_filename'])
    assert_equal('another_name_|.txt', msg_attachments[1]['custom_filename'])
    assert_equal('custom_name_2.zip', msg_attachments[2]['custom_filename'])
  end

  def test_add_attachment
    email = SendgridRuby::Email.new

    email.add_attachment("test/file1.txt")
    attachments = ["test/file1.txt"]
    msg_attachments = email.get_attachments
    assert_equal(attachments.length, msg_attachments.length)
    assert_equal(attachments[-1], msg_attachments[-1]['file'])
    assert_equal("test", msg_attachments[-1]['dirname'])
    assert_equal("file1.txt", msg_attachments[-1]['basename'])
    assert_equal(".txt", msg_attachments[-1]['extension'])
    assert_equal("file1", msg_attachments[-1]['filename'])
  end

  def test_add_attachment_custom_filename
    email = SendgridRuby::Email.new

    email.add_attachment("test/file1.txt", "different.txt")

    attachments = email.get_attachments
    assert_equal('different.txt', attachments[0]['custom_filename'])
    assert_equal('file1', attachments[0]['filename'])
  end

  def test_set_attachment
    email = SendgridRuby::Email.new

    # Setting an attachment removes all other files
    email.set_attachment("only_attachment.sad")

    assert_equal(1, email.get_attachments.length)

    # Remove an attachment
    email.remove_attachment("only_attachment.sad")
    assert_equal(0, email.get_attachments.length)
  end

  def test_set_attachment_custom_filename
    email = SendgridRuby::Email.new

    # Setting an attachment removes all other files
    email.set_attachment("only_attachment.sad", "different")

    attachments = email.get_attachments
    assert_equal(1, attachments.length)
    assert_equal('different', attachments[0]['custom_filename'])

    # Remove an attachment
    email.remove_attachment("only_attachment.sad")
    assert_equal(0, email.get_attachments.length)
  end


  def test_add_attachment_without_extension
    email = SendgridRuby::Email.new

    # ensure that addAttachment appends to the list of attachments
    email.add_attachment("../file_4")

    attachments = ["../file_4"]

    msg_attachments = email.get_attachments
    assert_equal(attachments[-1], msg_attachments[-1]['file'])
  end

  def test_category_accessors
    email = SendgridRuby::Email.new

    email.set_categories(['category_0'])
    assert_equal('{"category":["category_0"]}', email.smtpapi.json_string)

    categories = [
      "category_1",
      "category_2",
      "category_3",
      "category_4"
    ]

    email.set_categories(categories)

    # uses valid json
    assert_equal('{"category":["category_1","category_2","category_3","category_4"]}', email.smtpapi.json_string)
  end

  def test_substitution_accessors
    email = SendgridRuby::Email.new

    substitutions = {
      "sub_1" => ["val_1.1", "val_1.2", "val_1.3"],
      "sub_2" => ["val_2.1", "val_2.2"],
      "sub_3" => ["val_3.1", "val_3.2", "val_3.3", "val_3.4"],
      "sub_4" => ["val_4.1", "val_4.2", "val_4.3"]
    }

    email.set_substitutions(substitutions)

    assert_equal('{"sub":{"sub_1":["val_1.1","val_1.2","val_1.3"],"sub_2":["val_2.1","val_2.2"],"sub_3":["val_3.1","val_3.2","val_3.3","val_3.4"],"sub_4":["val_4.1","val_4.2","val_4.3"]}}', email.smtpapi.json_string)
  end

  def test_section_accessors
    email = SendgridRuby::Email.new

    sections = {
      "sub_1" => ["val_1.1", "val_1.2", "val_1.3"],
      "sub_2" => ["val_2.1", "val_2.2"],
      "sub_3" => ["val_3.1", "val_3.2", "val_3.3", "val_3.4"],
      "sub_4" => ["val_4.1", "val_4.2", "val_4.3"]
    }

    email.set_sections(sections)

    assert_equal('{"section":{"sub_1":["val_1.1","val_1.2","val_1.3"],"sub_2":["val_2.1","val_2.2"],"sub_3":["val_3.1","val_3.2","val_3.3","val_3.4"],"sub_4":["val_4.1","val_4.2","val_4.3"]}}', email.smtpapi.json_string)
  end

  def test_unique_args_accessors
    email = SendgridRuby::Email.new

    unique_arguments = {
      "sub_1" => ["val_1.1", "val_1.2", "val_1.3"],
      "sub_2" => ["val_2.1", "val_2.2"],
      "sub_3" => ["val_3.1", "val_3.2", "val_3.3", "val_3.4"],
      "sub_4" => ["val_4.1", "val_4.2", "val_4.3"]
    }

    email.set_unique_args(unique_arguments)

    assert_equal('{"unique_args":{"sub_1":["val_1.1","val_1.2","val_1.3"],"sub_2":["val_2.1","val_2.2"],"sub_3":["val_3.1","val_3.2","val_3.3","val_3.4"],"sub_4":["val_4.1","val_4.2","val_4.3"]}}', email.smtpapi.json_string)

    email.add_unique_arg('uncle', 'bob')

    assert_equal('{"unique_args":{"sub_1":["val_1.1","val_1.2","val_1.3"],"sub_2":["val_2.1","val_2.2"],"sub_3":["val_3.1","val_3.2","val_3.3","val_3.4"],"sub_4":["val_4.1","val_4.2","val_4.3"],"uncle":"bob"}}', email.smtpapi.json_string)
  end

  def test_header_accessors
    # A new message shouldn't have any RFC-822 headers set
    message = SendgridRuby::Email.new
    assert_equal('{}', message.smtpapi.json_string)

    # Add some message headers, check they are correctly stored
    headers = {
      'X-Sent-Using' => 'SendgridRuby-API',
      'X-Transport'  => 'web',
    }
    message.set_headers(headers)
    assert_equal(headers, message.get_headers)

    # Add another header, check if it is stored
    message.add_header('X-Another-Header', 'first_value')
    headers['X-Another-Header'] = 'first_value'
    assert_equal(headers, message.get_headers)

    # Replace a header
    message.add_header('X-Another-Header', 'second_value')
    headers['X-Another-Header'] = 'second_value'
    assert_equal(headers, message.get_headers)

    # Get the encoded headers; they must be a valid JSON
    json = message.get_headers_json
    decoded = JSON.parse(json)
    assert_equal(true, decoded.instance_of?(Hash))
    # Test we get the same message headers we put in the message
    assert_equal(headers, decoded)

    # Remove a header
    message.remove_header('X-Transport')
    headers.delete('X-Transport')
    assert_equal(headers, message.get_headers)
  end

  def test_to_web_format_empty
    email = SendgridRuby::Email.new
    json     = email.to_web_format
    xsmtpapi = JSON.parse(json["x-smtpapi"])
    assert_equal(nil, xsmtpapi['to'])
    assert_equal(nil, json['to'])
    assert_equal(nil, json['from'])
    assert_equal(nil, json['subject'])
    assert_equal(nil, json['text'])
    assert_equal(nil, json['html'])
    assert_equal("{}", json['headers'])
    # assert_equal([], json['cc'])
    # assert_equal([], json['bcc'])
    assert_equal(nil, json['fromname'])
    assert_equal(nil, json['replyto'])
  end

  def test_to_web_format_with_to
    email = SendgridRuby::Email.new
    email.add_to('foo@bar.com')
    email.set_from('from@site.com')
    json     = email.to_web_format
    xsmtpapi = JSON.parse(json["x-smtpapi"])

    assert_equal(['foo@bar.com'], xsmtpapi['to'])
    assert_equal('from@site.com', json['to'])
    assert_equal('from@site.com', json['from'])
  end

  def test_to_web_format_with_multi_to
    email = SendgridRuby::Email.new
    email.add_to('foo@bar.com')
    email.add_to('bar@site.com')
    json     = email.to_web_format
    xsmtpapi = JSON.parse(json["x-smtpapi"])

    assert_equal(['foo@bar.com','bar@site.com'], xsmtpapi['to'])
    assert_equal(nil, json['to'])
  end

  def test_to_web_format_with_to_fromname_and_replyto
    email = SendgridRuby::Email.new
    email.add_to('foo@bar.com')
    email.set_from('from@site.com')
    email.set_from_name('From Taro')
    email.set_reply_to('replyto@site.com')
    json     = email.to_web_format

    assert_equal('From Taro', json['fromname'])
    assert_equal('replyto@site.com', json['replyto'])
  end

  # def test_to_web_format_with_to_cc_and_bcc
  #   email = SendgridRuby::Email.new
  #   email.add_to('p1@mailinator.com')
  #   email.add_bcc('p2@mailinator.com')
  #   email.add_cc('p3@mailinator.com')
  #   json     = email.to_web_format

  #   assert_equal(['p2@mailinator.com'], json['bcc'])
  #   assert_equal(['p3@mailinator.com'], json['cc'])
  #   assert_equal('{"to":["p1@mailinator.com"]}', json["x-smtpapi"])
  # end

  def test_to_web_format_with_attachment
    email = SendgridRuby::Email.new
    email.add_attachment('./test/gif.gif')
    json     = email.to_web_format

    assert_equal(File.new("./test/gif.gif").path, json["files[gif.gif]"].path)
  end

  def test_to_web_format_with_attachment_custom_filename
    email = SendgridRuby::Email.new
    email.add_attachment('./test/gif.gif', 'different.jpg')
    json     = email.to_web_format

    assert_equal(File.new("./test/gif.gif").path, json["files[different.jpg]"].path)
  end

  def test_to_web_format_with_subject_and_body
    email = SendgridRuby::Email.new
    email.set_subject("This is the subject")
    email.set_text("This is the text of body")
    email.set_html("<strong>This is the html of body</strong>")
    json = email.to_web_format

    assert_equal("This is the subject", json['subject'])
    assert_equal("This is the text of body", json['text'])
    assert_equal("<strong>This is the html of body</strong>", json['html'])
  end

  def test_to_web_format_with_headers
    email = SendgridRuby::Email.new
    email.add_header('X-Sent-Using', 'SendgridRuby-API')
    json     = email.to_web_format

    headers = JSON.parse(json['headers'])
    assert_equal('SendgridRuby-API', headers['X-Sent-Using'])
  end

  def test_to_web_format_with_filters
    email = SendgridRuby::Email.new
    email.add_filter("footer", "text/plain", "Here is a plain text footer")
    json     = email.to_web_format

    xsmtpapi = JSON.parse(json['x-smtpapi'])
    assert_equal('Here is a plain text footer', xsmtpapi['filters']['footer']['settings']['text/plain'])
  end

end
