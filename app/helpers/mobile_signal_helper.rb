# frozen_string_literal: true

module MobileSignalHelper
  def mobile_signal_collection
    MaterialInfo.mobile_signals.map do |(supply, _int)|
      [t_mobile_signal(supply), supply]
    end
  end

  def t_mobile_signal(supply)
    t(supply, scope: mobile_label_scope)
  end

  private

  def mobile_label_scope
    "activerecord.attributes.material_info.mobile_signal_labels"
  end
end
