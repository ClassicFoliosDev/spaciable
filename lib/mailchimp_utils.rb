# frozen_string_literal: true

module MailchimpUtils
  module_function

  def client(api_key)
    Gibbon::Request.new(api_key: api_key)
  end
end
