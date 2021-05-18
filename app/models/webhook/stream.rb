# frozen_string_literal: true

module Webhook
  class Stream < ApplicationRecord
    require "open-uri"

    def self.image(asset, name)
      # MIME::Types.type_for(asset.file.file[/\.(?!\.)([a-zA-Z]*$)/,1])
      # file = open(ActionController::Base.helpers.asset_url(asset, type: type))
      # file.close
      # ActionController::Base.helpers.asset_url(asset, type: type)
      { filename: name,
        contents: "data:#{MIME::Types.type_for(name[/\.(?!\.)([a-zA-Z]*$)/, 1])&.first}," \
                  "#{Base64.strict_encode64(asset.file.read)}",
        private: false }
    end
  end
end
