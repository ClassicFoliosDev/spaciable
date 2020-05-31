# frozen_string_literal: true

# The regular Document class has restrictions on the way it expects to
# upload documents.  This class has no restrictions and is used to
# create CMS document entries in the documents table
module Crms
  class Document < ::ApplicationRecord
    self.table_name = "documents"
  end
end
