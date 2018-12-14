# frozen_string_literal: true

class DocumentUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  if Features.s3_storage?
    storage :aws
  else
    storage :file
  end

  def convert_to_image(height, width)
    image = MiniMagick::Image.open(current_path)
    image.resize "#{height}x#{width}"
    image.write(current_path)
  end

  version :preview, if: :not_svg? do
    # process convert_to_image: [210, 297]
    process convert: :jpg

    def full_filename(for_file = model.file)
      super.chomp(File.extname(super)) + ".jpg"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" +
  #      [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w[pdf PDF jpg jpeg gif png svg]
  end

  def fog_authenticated_url_expiration
    90.minutes # will be converted to seconds,  (default is 10.minutes)
  end

  def type_pdf?
    pdf?(file)
  end

  protected

  def not_svg?(new_file)
    !new_file.content_type.start_with? "image/svg+xml"
  end

  def pdf?(new_file)
    return unless new_file
    new_file.content_type.start_with? "application/pdf"
  rescue Aws::S3::Errors::Forbidden
    Rails.logger.info("S3 forbidden error, this may mean the file is not found in S3")
    # Return true so that the file is processed is PDF,
    # which means we will not try and preview it
    return true
  end
end
