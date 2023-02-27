# frozen_string_literal: true

class EnvVar < ApplicationRecord
  class << self
    # EnvVars retrieved by EnvVar[:symbol]
    def [](symbol)
      @env_vars ||= {}
      @env_vars[symbol] ||= EnvVar.find_by(name: symbol.to_s).value 
    end
  end
end
