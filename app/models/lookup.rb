# frozen_string_literal: true

class Lookup < ApplicationRecord
  class << self
    def parse(source, *instances)
      return if source.nil?

      parsed = source
      instances.each { |i| parse_against!(parsed, i) }
      parsed
    end

    # parse the string against the instance (ie a Plot)
    def parse_against!(parsed, i)
      @lookups ||= Lookup.all # get all the lookups for speed
      parsed.scan(/&lt;[a-z_]*&gt;/).each { |code| substitute_code!(parsed, i, code) }
      parsed.scan(/<[a-z_]*>/).each { |code| substitute_code!(parsed, i, code) }
    end

    def substitute_code!(parsed, i, code)
      lookup_code = code.tr("<>", "").gsub("&lt;", "").gsub("&gt;", "")
      @lookups ||= Lookup.all # get all the lookups for speed
      @lookups.where(code: lookup_code)
              .pluck(:column, :translation).each do |lookup, translation|
        fields = lookup.split(":") # split the lookup into Class and methods
        response = response_to(i, fields[1], translation) # Get the value of Plot.method/s
        next if (fields[0] != "*" && i.class.to_s != fields[0]) || response.nil?

        parsed.gsub!(code, response) # substitute the code with the value
      end
    end

    # the respond_to? function does not respond to linked
    # function calls like developer.company_name so we need
    # to recurse and call 'developer' on our top
    # level object (ie Plot) then 'company_name' on 'developer'
    # Enum columns will return a string representation which
    # requires the use of a translation to return the required value
    def response_to(i, attributes, t)
      funcs = attributes.split(".")
      if i.respond_to?(funcs[0])
        value = i.send(funcs[0])
        return response_to(value, funcs.drop(1).join("."), t) if funcs.count > 1

        case value
        when NilClass then return ""
        when String then return translate(value, t)
        when Date then return value.strftime("%d/%m/%Y")
        end
      end
      nil
    end

    def translate(source, translation)
      return source unless translation

      I18n.t("#{translation}.#{source}")
    end
  end
end
