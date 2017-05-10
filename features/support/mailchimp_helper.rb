# frozen_string_literal: true
class MailchimpHelper
  def self.stub_mailchimp
    WebMock.stub_request(:put, %r{https:\/\/us14.api.mailchimp.com\/3\.0\/lists\/.*\/members\/.*})
           .to_return(status: 200, body: "Stubbed response")
  end
end
