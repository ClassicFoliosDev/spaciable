# frozen_string_literal: true

class BrandedApp < ApplicationRecord
  mount_uploader :app_icon, PictureUploader
  attr_accessor :app_icon_cache

  belongs_to :app_owner, polymorphic: true

  alias parent app_owner

  validates :apple_link, :android_link, presence: true, on: :update, format: {
    with: %r{\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z},
    message: I18n.t("activerecord.errors.messages.url_format")
  }

  def self.missing_attributes?(app_parent)
    branded_app = app_parent.branded_app
    return unless branded_app

    branded_app.attributes.each do |_attr, val|
      return true if val.nil? || val == ""
    end
    false
  end

  # link to the spaciable app if the app owner does not have a branded link or a branded app
  def self.relevant_link(user_agent, app_parent)
    return unless user_agent
    user_agent = user_agent.downcase
    if user_agent =~ /android/
      android_link(app_parent)
    elsif user_agent =~ /iphone/
      apple_link(app_parent)
    end
  end

  def self.android_link(app_parent)
    if app_parent&.branded_app&.android_link?
      app_parent.branded_app_android_link
    else
      "https://play.google.com/store/apps/details?id=io.gonative.android.kodlkr&hl=en_GB"
    end
  end

  def self.apple_link(app_parent)
    if app_parent&.branded_app&.apple_link?
      app_parent.branded_app_apple_link
    else
      # rubocop:disable LineLength
      "https://apps.apple.com/app/apple-store/id1454008219?pt=119736329&ct=download%20reminder&mt=8"
      # rubocop:enable LineLength
    end
  end

  # show the spaciable logo if the app owner does not have a branded app icon or a branded app
  def self.relevant_icon(app_parent)
    app_parent&.branded_app&.app_icon? ? app_parent.branded_app_app_icon : "Spaciable_icon.png"
  end
end
