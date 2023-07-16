# frozen_string_literal: true

class EnvVar < ApplicationRecord
  class << self
    # EnvVars retrieved by EnvVar[:symbol]
    def [](symbol, read = false)
      @env_vars ||= {}
      return EnvVar.find_by(name: symbol.to_s).value if read
      @env_vars[symbol] ||= EnvVar.find_by(name: symbol.to_s).value
    end

    def update(name, value)
      EnvVar.find_by(name: name)&.update_column(:value, value)
    end
  end
end
