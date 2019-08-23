# frozen_string_literal: true

module LettingsHelper
  def letable_types_collection
    Plot.letable_types.map do |(letable_name, _letable_int)|
      [t(letable_name, scope: letable_types_scope), letable_name]
    end
  end

  private

  def letable_types_scope
    "activerecord.attributes.plot.letable_types"
  end
end
