class MigrateDivisions < ActiveRecord::Migration[5.0]
  def up
    Rake::Task['crest:migrate'].invoke unless Rails.env.test?
    Rake::Task['countryside:migrate'].invoke unless Rails.env.test?
  end
end
