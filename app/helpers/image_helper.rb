
# frozen_string_literal: true

module ImageHelper
  def image_alt(url)
    url.include?("/") ? 
      url[/^.*\/(.[^\.]*)/,1]&.gsub(/[_-]/,' ')&.capitalize :
      url[/([^\.]*)/,1]&.gsub(/[_-]/,' ')&.capitalize
  end
end