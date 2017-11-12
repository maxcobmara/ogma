require 'spec_helper'
require "#{Rails.root}/db/migrate/20171107050528_change_columns_to_timetable_periods"
require "#{Rails.root}/db/migrate/20171109071718_reset_library_catalogs"
require "#{Rails.root}/db/migrate/20171109075052_recreate_library_catalogs"

describe RecreateLibraryCatalogs do
  
  describe 'up' do

    before do
# #       @prev_migration='20171109071718'
# #       ActiveRecord::Migrator.migrate @prev_migration
# #       puts "Run previous migration : drop tables (in order to REcreate) : #{ActiveRecord::Migrator.current_version} "
# #       puts "accessions : #{ActiveRecord::Base.connection.tables.include?("accessions")}"
    
#       1) To test after reset_library_catalogs, remark below 4 lines 
#       2) To repeat just this test OR $ bundle exec rspec : UNremark below 4 lines
      RecreateLibraryCatalogs.down
      puts "DROP first to test create"
      puts "Current migration : #{ActiveRecord::Migrator.current_version}"   
      puts "#{ActiveRecord::Base.connection.tables.include?("books")==true ? 'tables exists' : 'tables not exists'}"
    end
    
    it 'recreate books, accessions and booksearches tables' do
      expect{ RecreateLibraryCatalogs.up }.to change{ActiveRecord::Base.connection.tables.count}
      table_list=ActiveRecord::Base.connection.tables
      table_list.should include("books")
      table_list.should include("accessions")
      table_list.should include("booksearches")
      
      puts "#{table_list.should include("books")} ~~ #{table_list.should include("accessions")} ~~#{table_list.should include("booksearches")}"
    end
  end
  
#   after(:all) do
#     RecreateLibraryCatalogs.down
#     puts "Drop tables back"
#   end
end
  