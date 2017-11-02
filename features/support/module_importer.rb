# frozen_string_literal: true

module ModuleImporter
  module_function

  def import_module(mod)
    module_eval <<-RUBY, __FILE__, __LINE__
      def self.respond_to_missing?(method, *args)
        #{mod}.methods.include?(method) || super
      end

      def self.method_missing(method, *args)
        if #{mod}.methods.include?(method)
          #{mod}.send(method, *args)
        else
          super
        end
      end
    RUBY
  end
end
