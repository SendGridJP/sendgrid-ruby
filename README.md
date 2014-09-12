# sendgrid_ruby

This gem allows you to quickly and easily send emails through SendGrid using Ruby.  
See [Usage](https://github.com/SendGridJP/sendgridjp-ruby-example).  

[![Build Status](https://travis-ci.org/SendGridJP/sendgrid-ruby.svg?branch=master)](https://travis-ci.org/SendGridJP/sendgrid-ruby)

```Ruby
email = SendgridRuby::Email.new
email.add_to('foo@bar.com')
.add_to('dude@bar.com')
.set_from(me@bar.com)
.set_subject("Subject goes here")
.set_text("Hello World!")
.set_html("<strong>Hello World!</strong><br />")

sendgrid = SendgridRuby::Sendgrid.new('username', 'password')
sendgrid.send(email)
```

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid_ruby

## Example App

There is a [sendgridjp-ruby-example app](https://github.com/sendgridjp/sendgridjp-ruby-example) to help jumpstart your development.

## Usage

To begin using this gem, initialize the SendGrid object with your SendGrid credentials.

```Ruby
sendgrid = SendgridRuby::Sendgrid.new('username', 'password')
```

Create a new SendGrid Email object and add your message details.

```Ruby
mail = SendgirdRuby::Email.new
mail.add_to('foo@bar.com')
    .setFrom('me@bar.com')
    .setSubject('Subject goes here')
    .setText('Hello World!')
    .setHtml('<strong>Hello World!</strong>')
```

Send it.

```Ruby
response = sendgrid.send(mail)
```

### add_to

You can add one or multiple TO addresses using `add_to`.

```Ruby
mail = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    .add_to('another@another.com')
sendgrid.send(mail)
```

### set_tos

If you prefer, you can add multiple TO addresses as an array using the `set_tos` method. This will unset any previous `add_to`s you appended.

```Ruby
mail   = SendgridRuby::Email.new
emails = ["foo@bar.com", "another@another.com", "other@other.com"]
mail.set_tos(emails)
sendgrid.send(mail)
```

### get_tos

Sometimes you might find yourself wanting to list the currently set Tos. You can do that with `get_tos`.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
mail.get_tos
```

### remove_to

You might also find yourself wanting to remove a single TO from your set list of TOs. You can do that with `remove_to`. You can pass a string or regex to the remove_to method.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
mail.remove_to('foo@bar.com')
```

### set_from

```Ruby
mail   = SendgridRuby::Email.new
mail.set_from('foo@bar.com')
sendgrid.send(mail)
```

### set_from_name

```Ruby
mail   = SendgridRuby::Email.new
mail.set_from('foo@bar.com')
mail.set_from_name('Foo Bar')
mail.set_from('other@example.com')
mail.set_from_name('Other Guy')
sendgrid.send($mail)
```

### set_reply_to

```Ruby
mail   = SendgridRuby::Email.new
mail.set_reply_to('foo@bar.com')
sendgrid.send(mail)
```

### Bcc

Use multiple `add_to`s as a superior alternative to `set_bcc`.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    .add_to('someotheraddress@bar.com')
    .add_to('another@another.com')
       ...
```

### set_subject

```Ruby
mail   = SendgridRuby::Email.new
mail.set_subject('This is a subject')
sendgrid.send(mail)
```

### set_text

```Ruby
mail   = SendgridRuby::Email.new
mail.set_text('This is some text')
sendgrid.send(mail)
```

### set_html

```Ruby
mail   = SendgridRuby::Email.new
mail.set_html('<h1>This is an html email</h1>')
sendgrid.send(mail)
```

### Categories ###

Categories are used to group email statistics provided by SendGrid.

To use a category, simply set the category name.  Note: there is a maximum of 10 categories per email.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_category("Category 1")
    .add_category("Category 2")
```

### Attachments ###

Attachments are currently file based only.

File attachments are limited to 7 MB per file.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_attachment("../path/to/file.txt")
```

If you use the multiple add_to, each user will receive a personalized email showing **only* their email. This is more friendly and more personal.

So just remember, when thinking 'bcc', instead use multiple `addTo`s.

### From-Name and Reply-To

There are two handy helper methods for setting the From-Name and Reply-To for a
message

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    .set_reply_to('someone.else@example.com')
    .set_from_name('John Doe')
    ...
```

### Substitutions ###

Substitutions can be used to customize multi-recipient emails, and tailor them for the user

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('john@somewhere.com')
    .add_to("harry@somewhere.com")
    .add_to("Bob@somewhere.com")
    ...
    .set_html("Hey name, we've seen that you've been gone for a while")
    .add_substitution("name", ["John", "Harry", "Bob"])
```

### Sections ###

Sections can be used to further customize messages for the end users. A section is only useful in conjunction with a substition value.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('john@somewhere.com')
    .add_to("harry@somewhere.com")
    .add_to("Bob@somewhere.com")
    ...
    .set_html("Hey name, you work at place")
    .add_substitution("name", ["John", "Harry", "Bob"])
    .add_substitution("place", ["office", "office", "home"])
    .add_section("office", "an office")
    .add_section("home", "your house")
```

### Unique Arguments ###

Unique Arguments are used for tracking purposes

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_unique_arg("Customer", "Someone")
    .add_unique_arg("location", "Somewhere")
    .set_unique_args({'cow' => 'chicken'})
```

### Filter Settings ###

Filter Settings are used to enable and disable apps, and to pass parameters to those apps.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_filter("gravatar", "enable", 1)
    .add_filter("footer", "enable", 1)
    .add_filter("footer", "text/plain", "Here is a plain text footer")
    .add_filter("footer", "text/html", "<p style='color:red;'>Here is an HTML footer</p>")
```

### Scheduled send ###

You can specify delay to send. There are 2 parameters for delay sending.

#### send_at ####
```Ruby
mail   = SendgridRuby::Email.new
localtime = Time.local(2014, 8, 29, 17, 56, 35)
mail.set_send_at(localtime)
```

#### send_each_at ####
```Ruby
mail   = SendgridRuby::Email.new
localtime1 = Time.local(2014,  8, 29, 17, 56, 35)
localtime2 = Time.local(2013, 12, 31,  0,  0,  0)
localtime3 = Time.local(2015,  9,  1,  4,  5,  6)
mail.set_send_each_at([localtime1, localtime2, localtime3])
```

### Headers ###

You can add standard email message headers as necessary.

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_header('X-Sent-Using', 'SendGrid-API')
    .add_header('X-Transport', 'web')
```

### Output debug log ###

You can output the log for debug to $stderr

```Ruby
mail   = SendgridRuby::Email.new
mail.add_to('foo@bar.com')
    ...
    .add_header('X-Sent-Using', 'SendGrid-API')
    .add_header('X-Transport', 'web')

sendgrid = SendgridRuby::Sendgrid.new(sendgrid_username, sendgrid_password)
sendgrid.debug_output = true
sendgrid.send(mail)
```

### Sending to 1,000s of emails in one batch

Sometimes you might want to send 1,000s of emails in one request. You can do that. It is recommended you break each batch up in 1,000 increements. So if you need to send to 5,000 emails, then you'd break this into a loop of 1,000 emails at a time.

```Ruby
sendgrid = SendgridRuby::Sendgrid.new(sendgrid_username, sendgrid_password)
mail   = SendgridRuby::Email.new

recipients = ["alpha@mailinator.com", "beta@mailinator.com", "zeta@mailinator.com"]
names      = ["Alpha", "Beta", "Zeta"]

email.set_from("from@mailinator.com")
    .set_subject('[sendgrid-ruby-batch-email]')
    .set_tos($recipients)
    .add_substitution("name", $names)
    .set_text("Hey name, we have an email for you")
    .set_html("<h1>Hey name, we have an email for you</h1>")

result = sendgrid.send(mail)
```

### Ignoring SSL certificate verification

You can optionally ignore verification of SSL certificate when using the Web API.

```Ruby
options = {"turn_off_ssl_verification" => true}
sendgrid  = SendgridRuby::Sendgrid.new(SENDGRID_USERNAME, SENDGRID_PASSWORD, options)

mail    = SendgridRuby::Email.new
...
result  = sendgrid.send(email)
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/sendgrid/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Running Test

The existing tests in the `test` directory can be run using unit test.

````bash
rake test
```
