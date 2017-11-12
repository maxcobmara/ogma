require 'spec_helper'
# require "#{Rails.root}/db/migrate/20171109075052_recreate_library_catalogs"
# require "#{Rails.root}/db/migrate/20171111115602_reset_library_transactions"
require "#{Rails.root}/db/migrate/20171111115637_recreate_library_transactions"

describe RecreateLibraryTransactions do
  
  describe 'up' do

    before do
#        1) To test after reset_library_catalogs, remark below 4 lines 
#        2) To repeat just this test OR $ bundle exec rspec : UNremark below 4 lines
      RecreateLibraryTransactions.down
      puts "DROP first to test create"
      puts "Current migration : #{ActiveRecord::Migrator.current_version}"   
      puts "#{ActiveRecord::Base.connection.tables.include?("books")==true ? 'tables exists' : 'tables not exists'}"
    end
    
    it 'recreate librarytransactions and librarytransactionsearches tables' do
      expect{ RecreateLibraryTransactions.up}.to change{ActiveRecord::Base.connection.tables.count} 
      table_list=ActiveRecord::Base.connection.tables
      table_list.should include("librarytransactions")
      table_list.should include("librarytransactionsearches")
      
      puts "#{table_list.should include("librarytransactions")} ~~ #{table_list.should include("librarytransactionsearches")}"
    end
  end
  
#   after(:all) do
#     RecreateLibraryTransactions.down
#     puts "Drop tables back"
#   end
end

