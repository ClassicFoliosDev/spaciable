# frozen_string_literal: true

namespace :cas_package do
  task initialise: :environment do
    clean_cas
  end

  def clean_cas
    [Finish, FinishManufacturer, FinishType, FinishCategory,
     Appliance, ApplianceManufacturer, ApplianceCategory].each do |klass|
       klass.where.not(developer_id: nil).destroy_all
       next unless klass.respond_to?("only_deleted")
       klass.only_deleted.each { |record| record.really_destroy! }
    end
  end
end
