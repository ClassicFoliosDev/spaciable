# frozen_string_literal: true

namespace :spotlight_seq do
  task :initialise, [:arg1] => :environment  do |t, args|
    ActiveRecord::Base.connection.execute("CREATE SEQUENCE spotlight_seq START #{args[:arg1]};")
  end
end