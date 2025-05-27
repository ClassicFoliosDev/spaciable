class File
    def mime_type
        `file --brief --mime-type #{self.path}`.strip
    end

    def charset
        `file --brief --mime #{self.path}`.split(';').second.split('=').second.strip
    end
end