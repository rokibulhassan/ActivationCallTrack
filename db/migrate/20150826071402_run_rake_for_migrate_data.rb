class RunRakeForMigrateData < ActiveRecord::Migration
  def self.up
    Rake::Task["data:map"].invoke
  end
end
