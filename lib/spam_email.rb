require "spam_email/version"
require "spam_email/blacklist"
require 'active_model'
require 'active_model/validations'
require 'mail'

I18n.load_path += Dir.glob(File.expand_path('../../config/locales/**/*',__FILE__))

class SpamEmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      m = Mail::Address.new(value)
      return if m.domain.nil?
      domain = m.domain.downcase

      if SpamEmail::BLACKLIST.include?(domain)
        message = (options[:message] || I18n.t(:blacklisted, scope: "spam_email.validations.email"))
        record.errors[attribute] << message
      end
    rescue Mail::Field::ParseError
      return
    end
  end
end
