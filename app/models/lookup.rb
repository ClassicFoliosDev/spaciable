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
    def parse_against!(parsed, ins)
      @lookups ||= Lookup.all # get all the lookups for speed
      parsed.scan(/&lt;[a-z_]*&gt;/).each { |code| substitute_code!(parsed, ins, code) }
      parsed.scan(/<[a-z_]*>/).each { |code| substitute_code!(parsed, ins, code) }
    end

    def substitute_code!(parsed, ins, code)
      lookup_code = code.tr("<>", "").gsub("&lt;", "").gsub("&gt;", "")
      @lookups ||= Lookup.all # get all the lookups for speed
      @lookups.where(code: lookup_code)
              .pluck(:column, :translation).each do |lookup, translation|
        fields = lookup.split(":") # split the lookup into Class and methods
        response = response_to(ins, fields[1], translation) # Get the value of Plot.method/s
        next if fields[0] != "*" && ins.class.to_s != fields[0]

        # substitute the code with the value or "" if no value available
        parsed.gsub!(code, response || "")
      end
    end

    # the respond_to? function does not respond to linked
    # function calls like developer.company_name so we need
    # to recurse and call 'developer' on our top
    # level object (ie Plot) then 'company_name' on 'developer'
    # Enum columns will return a string representation which
    # requires the use of a translation to return the required value
    def response_to(ins, attributes, trans)
      funcs = attributes.split(".")
      if ins.respond_to?(funcs[0])
        value = ins.send(funcs[0])
        return response_to(value, funcs.drop(1).join("."), trans) if funcs.count > 1

        case value
        when NilClass then return ""
        when String then return translate(value, trans)
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
