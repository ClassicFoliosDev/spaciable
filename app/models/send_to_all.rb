# frozen_string_literal: true
class SendToAll
  include ActiveModel::Model

  attr_accessor :notification

  def id
    nil
  end

  def type
    nil
  end

  def plots
    Plot.all
  end

  def to_s
    I18n.t("activerecord.attributes.send_to_all.all")
  end
  alias to_str to_s
end
