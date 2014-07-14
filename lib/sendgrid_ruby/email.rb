# -*- encoding: utf-8 -*-
require 'smtpapi'
require 'json'

module SendgridRuby

  class Email

    def initialize()
      @smtpapi = Smtpapi::Header.new
      @cc_list = []
      @bcc_list = []
      @attachments = []
      @headers = Hash.new
    end

    def remove_from_list(list, item, key_field = nil)
      list.each do |value|
        if key_field == nil
          list.delete(value) if (value == item)
        else
          list.delete(value) if (value[key_field] == item)
        end
      end
      list
    end

    def add_to(email, name=nil)
      @smtpapi.add_to(email, name)
      self
    end

    def set_tos(emails)
      @smtpapi.set_tos(emails)
      self
    end

    def get_tos
      @smtpapi.to
    end

    def remove_to(email)
      remove_from_list(@smtpapi.to, email)
      self
    end

    def set_from(email)
      @from = email
      self
    end

    def get_from(as_array = false)
      if as_array && name = @from_name
        {@from => name}
      else
        @from
      end
    end

    def set_reply_to(reply_to)
      @reply_to = reply_to
      self
    end

    def get_reply_to
      @reply_to
    end

    def set_from_name(from_name)
      @from_name = from_name
      self
    end

    def get_from_name
      @from_name
    end

    # def set_cc(email)
    #   @cc_list = [email]
    #   self
    # end

    # def set_ccs(email_list)
    #   @cc_list = email_list
    #   self
    # end

    # def add_cc(email)
    #   @cc_list.push(email)
    #   self
    # end

    # def remove_cc(email)
    #   @cc_list = remove_from_list(@cc_list, email)
    #   self
    # end

    # def get_ccs
    #   @cc_list
    # end

    # def set_bcc(email)
    #   @bcc_list = [email]
    #   self
    # end

    # def set_bccs(email_list)
    #   @bcc_list = email_list
    #   self
    # end

    # def add_bcc(email)
    #   @bcc_list.push(email)
    #   self
    # end

    # def remove_bcc(email)
    #   @bcc_list = remove_from_list(@bcc_list, email)
    #   self
    # end

    # def get_bccs
    #   @bcc_list
    # end

    def set_subject(subject)
      @subject = subject
      self
    end

    def get_subject
      @subject
    end

    def set_text(text)
      @text = text
      self
    end

    def get_text
      @text
    end


    def set_html(html)
      @html = html
      self
    end

    def get_html
      @html
    end

    attr_accessor :smtpapi

    def set_attachments(files)
      files.each do |filename, file|
        if file.is_a?(String)
          add_attachment(file, filename)
        else
          add_attachment(filename)
        end
      end
      self
    end

    def set_attachment(file, custom_filename=nil)
      @attachments = [get_attachment_info(file, custom_filename)]
      self
    end

    def add_attachment(file, custom_filename=nil)
      @attachments.push(get_attachment_info(file, custom_filename))
      self
    end

    def get_attachments()
      @attachments
    end

    def remove_attachment(file)
      @attachments = remove_from_list(@attachments, file, "file")
      self
    end

    def get_attachment_info(file, custom_filename=nil)
      dir, basename = File::split(file)
      extname = File::extname(file)
      filename = File::basename(file, extname)
      info = {
        'dirname' => dir,
        'basename' => basename,
        'extension' => extname,
        'filename' => filename
      }
      info['file'] = file
      info['custom_filename'] = custom_filename if !custom_filename.nil?
      info
    end

    def set_categories(categories)
      @smtpapi.set_categories(categories)
      self
    end

    def set_category(category)
      @smtpapi.set_category(category)
      self
    end

    def add_category(category)
      @smtpapi.add_category(category)
      self
    end

    def remove_category(category)
      @smtpapi.remove_category(category)
      self
    end

    def set_substitutions(key_value_pairs)
      @smtpapi.set_substitutions(key_value_pairs)
      self
    end

    def add_substitution(from_value, to_values)
      @smtpapi.add_substitution(from_value, to_values)
      self
    end

    def set_sections(key_value_pairs)
      @smtpapi.set_sections(key_value_pairs)
      self
    end

    def add_section(from_value, to_value)
      @smtpapi.add_section(from_value, to_value)
      self
    end

    def set_unique_args(key_value_pairs)
      @smtpapi.set_unique_args(key_value_pairs)
      self
    end

    def add_unique_arg(key, value)
      @smtpapi.add_unique_arg(key, value)
      self
    end

    def set_filters(filter_settings)
      @smtpapi.set_filters(filter_settings)
      self
    end

    def add_filter(filter_name, parameter_name, parameter_value)
      @smtpapi.add_filter(filter_name, parameter_name, parameter_value)
    end

    def get_headers()
      @headers
    end

    def get_headers_json()
      JSON.generate(@headers)
    end

    def set_headers(key_value_pairs)
      @headers = key_value_pairs
      self
    end

    def add_header(key, value)
      @headers[key] = value
      self
    end

    def remove_header(key)
      @headers = remove_from_list(@headers, key)
      self
    end

    def to_web_format()
      web = {
        'to'          => @to,
        'from'        => get_from,
        'x-smtpapi'   => @smtpapi.to_json,
        'subject'     => @subject,
        'text'        => @text,
        'html'        => @html,
        'headers'     => get_headers_json,
      }

      # web['cc']         = get_ccs     if get_ccs
      # web['bcc']        = get_bccs    if get_bccs
      web['fromname']   = @from_name  if @from_name
      web['replyto']    = @reply_to   if @reply_to
      web['to']         = @from       if (@smtpapi.to && @smtpapi.to.length > 0)

      if get_attachments
        get_attachments.each do |f|

          file          = f['file']
          extension     = f['extension']
          filename      = f['filename']
          full_filename = filename
          full_filename = filename + extension if extension
          full_filename = f['custom_filename'] if f['custom_filename']

          contents   = File.new(file, 'rb')

          web["files[#{full_filename}]"] = contents
        end
      end
      web
    end

  end
end
