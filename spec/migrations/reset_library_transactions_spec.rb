require 'spec_helper'
require "#{Rails.root}/db/migrate/20171109075052_recreate_library_catalogs"
require "#{Rails.root}/db/migrate/20171111115602_reset_library_transactions"
# require "#{Rails.root}/db/migrate/20171111115637_recreate_library_transactions"

describe ResetLibraryTransactions do

  describe 'up' do
    before do
#       ResetLibraryTransactions.down
#       puts "CREATE first to test drop"
#       puts "Current migration : #{ActiveRecord::Migrator.current_version}"   
#       puts "#{ActiveRecord::Base.connection.tables.include?("librarytransactions")==true ? 'tables exists' : 'tables not exists'}"
    end
    
    it 'drops librarytransactions and librarytransactionsearches tables' do
      
      puts "before : #{ActiveRecord::Base.connection.tables.count}"
      expect{ ResetLibraryTransactions.up}.to change{ActiveRecord::Base.connection.tables.count} #rescue nil
      puts "after : #{ActiveRecord::Base.connection.tables.count}"
      
      assert_equal true, !Librarytransaction.table_exists?
      assert_equal true, !Librarytransactionsearch.table_exists?
      
      puts "#{!Librarytransaction.table_exists?} ~ #{!Librarytransactionsearch.table_exists?}"
      
      #REF : https://github.com/rails/rails/blob/master/activerecord/test/cases/migration_test.rb#L84
    end
    
  end
#   after(:all) do
#     ResetLibraryTransactions.down
#     puts "Create tables back"
#   end
  
end