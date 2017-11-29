CarrierWave.configure do |config|
  if Features.s3_storage?
    config.storage    = :aws
    config.aws_bucket = Rails.application.secrets.s3_bucket
    config.aws_acl    = 'private'

    # Optionally define an asset host for configurations that are fronted by a
    # content host, such as CloudFront.
    #config.asset_host = 'http://example.com'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching
    config.aws_attributes = {
        expires: 1.week.from_now.httpdate,
        cache_control: 'max-age=315576000'
    }

    config.aws_credentials = {
        access_key_id:     Rails.application.secrets.aws_key,
        secret_access_key: Rails.application.secrets.aws_secret,
        region:            'eu-west-1', # Required
    }

    # Optional: Signing of download urls, e.g. for serving private content through
    # CloudFront. Be sure you have the `cloudfront-signer` gem installed and
    # configured:
    # config.aws_signer = -> (unsigned_url, options) do
    #   Aws::CF::Signer.sign_url(unsigned_url, options)
    # end
  end
end
