# frozen_string_literal: true

class EnvVar < ApplicationRecord
  # rubocop:disable Lint/HandleExceptions
  class << self
    # initialise is called when the application starts.  It dynamically creates
    # a class function/accessor for each entry in the EnvVar table
    def initialise
      EnvVar.find_each do |env_var|
        EnvVar.singleton_class.class_eval do
          define_method env_var.name do
            env_var.value
          end
        end
      end
    rescue ActiveRecord::StatementInvalid
      # ignore - this will only happen when the migration
      # that adds the EnvVar table first runs
    end
  end
  # rubocop:enable Lint/HandleExceptions
end
