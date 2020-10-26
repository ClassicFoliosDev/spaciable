# frozen_string_literal: true

# When a 'has_many through' relationship is used as an association
# then ActiveRecord uses a 'delete' to remove the associated records
# If the associated record has dependencies then they are NOT deleted
# because the code is using 'delete' instead of 'destroy'.  So this code
# allows a relationship to be tagged as 'replace_with_destroy' and then
# the replace_records function is overridden to perform a 'destroy'
# and the dependencies get deleted.  This code was taken from a the
# replace_with_destroy gem https://github.com/cyberxander90/replace_with_destroy
# The gem requires a newer version of rails and so the code was added
# directly instead
module ActiveRecord
  module Associations
    class CollectionAssociation < Association #:nodoc:
      private

      def replace_records(new_target, original_target)
        if self.options[:replace_with_destroy]
          destroy(target - new_target)
        else
          delete(target - new_target)
        end

        unless concat(new_target - target)
          @target = original_target
          raise RecordNotSaved, "Failed to replace #{reflection.name} because one or more of the " \
                                "new records could not be saved."
        end

        target
      end
    end
  end
end

ActiveRecord::Associations::Builder::Association::VALID_OPTIONS << :replace_with_destroy
