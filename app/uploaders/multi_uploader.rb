# frozen_string_literal: true

class MultiUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  if Features.s3_storage?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png pdf PDF)
  end

  def fog_authenticated_url_expiration
    6.minutes # will be converted to seconds,  (default is 10.minutes)
  end
end
