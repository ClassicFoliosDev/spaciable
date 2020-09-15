class CrestDivisions < ActiveRecord::Migration[5.0]
  def up
    Rake::Task['crest:migrate'].invoke unless Rails.env.test?
  end
end
