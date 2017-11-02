# frozen_string_literal: true

module Features
  module_function

  def seed_output
    !Rails.env.test?
  end

  def s3_storage?
    hosted_env
  end

  def bullet_footer?
    Rails.env.development? || Rails.env.qa?
  end

  def rollbar?
    hosted_env
  end

  def raise_missing_translation_exceptions?
    debugging_env
  end

  private

  module_function

  def debugging_env
    Rails.env.qa? || Rails.env.development? || Rails.env.test?
  end

  def hosted_env
    Rails.env.production? || Rails.env.staging? || Rails.env.qa?
  end
end
