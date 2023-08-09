# frozen_string_literal: true

# rubocop:disable Style/MultilineTernaryOperator, Layout/SpaceAfterComma, Style/RegexpLiteral
module ImageHelper
  def image_alt(url)
    url.include?("/") ?
      url[/^.*\/(.[^\.]*)/,1]&.gsub(/[_-]/," ")&.capitalize :
      url[/([^\.]*)/,1]&.gsub(/[_-]/," ")&.capitalize
  end
end
# rubocop:enable Style/MultilineTernaryOperator, Layout/SpaceAfterComma, Style/RegexpLiteral
