# frozen_string_literal: true

module OpenURI
  class Buffer
  	def <<(str)
      @io << str
      @size += str.length
      if StringIO === @io && StringMax < @size
        require 'tempfile'
        filename = ['open-uri']
        filename << ".pdf" if caller.index{|s| s.include?("sync_with_unlatch")}.present?
        io = Tempfile.new(filename)
        io.binmode
        Meta.init io, @io if Meta === @io
        io << @io.string
        @io = io
      end
    end
  end
end