require 'spec_helper'
require "#{Rails.root}/db/migrate/20171107050528_change_columns_to_timetable_periods"
require "#{Rails.root}/db/migrate/20171109071718_reset_library_catalogs"
# require "#{Rails.root}/db/migrate/20171109075052_recreate_library_catalogs"

describe ResetLibraryCatalogs do
#   before {@prev_migration='20171107050528' }
#   before {@this_migration='20171109071718'}
          
  describe 'up' do
    before do
#       ActiveRecord::Migrator.rollback @this_migration
#       ActiveRecord::Migrator.rollback @prev_migration
#       puts "Migrate prev(table exist) #{@prev_migration} : (in order to DRop)" 
      
#       ResetLibraryCatalogs.down
#       puts "CREATE first to test drop"
#       puts "Current migration : #{ActiveRecord::Migrator.current_version}"   
#       puts "#{ActiveRecord::Base.connection.tables.include?("books")==true ? 'tables exists' : 'tables not exists'}"
    end
    
    it 'drops books, accessions and booksearches tables' do
      
      puts "before : #{ActiveRecord::Base.connection.tables.count}"
      expect{ ResetLibraryCatalogs.up }.to change{ActiveRecord::Base.connection.tables.count} #rescue nil
      puts "after : #{ActiveRecord::Base.connection.tables.count}"
      
      assert_equal true, !Book.table_exists?
      assert_equal true, !Accession.table_exists?
      assert_equal true, !Booksearch.table_exists?
      
      puts "#{!Book.table_exists?} ~ #{!Accession.table_exists?} ~ #{!Booksearch.table_exists?}"
      
      #REF : https://github.com/rails/rails/blob/master/activerecord/test/cases/migration_test.rb#L84
    end
    
  end
#   after(:all) do
#     ResetLibraryCatalogs.down
#     puts "Create tables back"
#   end
  
end

 
#COMBINED
# describe ResetLibraryCatalogs do
#   
#   @table_listing=ActiveRecord::Base.connection.tables
#   
#   
#   if !@table_listing.include?("books") && !@table_listing.include?("accessions") && !@table_listing.include?("booksearches") 
#     
#     describe 'up (drop) when table not exist' do
#       before do
# 	@migration='20171109075052'#'20171107050528'
# 	ActiveRecord::Migrator.migrate @migration
# 	puts "Migrate prev/later(create) (in order to DRop) : "
#       end
#       
#       it 'drops books, accessions and booksearches tables' do
# 	puts "ONE"
# 	ResetLibraryCatalogs.up 
# 	table_list=ActiveRecord::Base.connection.tables
# 	table_list.should_not include("books")
# 	table_list.should_not include("accessions")
# 	table_list.should_not include("booksearches")
#       end
#     end
#     
#   end
#   
#   if @table_listing.include?("books") && @table_listing.include?("accessions") && @table_listing.include?("booksearches") 
#     
#     describe 'up (drop) when table already exist' do
#       
#       it 'drops books, accessions and booksearches tables' do
# 	puts "TWO"
# 	ResetLibraryCatalogs.up 
# 	table_list=ActiveRecord::Base.connection.tables
# 	table_list.should_not include("books")
# 	table_list.should_not include("accessions")
# 	table_list.should_not include("booksearches")
#       end
#     end
#   end
#   
# end
# 
# describe RecreateLibraryCatalogs do
#   
#   @table_listing=ActiveRecord::Base.connection.tables
#   
#   if @table_listing.include?("books") && @table_listing.include?("accessions") && @table_listing.include?("booksearches") 
#     describe 'up (create) when table already exist' do
#       before do
# 	@prev_migration='20171109071718'
# 	ActiveRecord::Migrator.migrate @prev_migration
# 	puts "Migrate previous(drop) (in order to REcreate) : "
#       end
#       
#       it 'recreate books, accessions and booksearches tables' do
# 	puts "THREE"
# 	RecreateLibraryCatalogs.up 
# 	table_list=ActiveRecord::Base.connection.tables
# 	table_list.should include("books")
# 	table_list.should include("accessions")
# 	table_list.should include("booksearches")
#       end
#       
#     end
#   end
#   
#    if !@table_listing.include?("books") && !@table_listing.include?("accessions") && !@table_listing.include?("booksearches") 
#      describe 'up (create) when table not exist' do
#       
#       it 'recreate books, accessions and booksearches tables' do
# 	puts "FOUR"
# 	RecreateLibraryCatalogs.up 
# 	table_list=ActiveRecord::Base.connection.tables
# 	table_list.should include("books")
# 	table_list.should include("accessions")
# 	table_list.should include("booksearches")
#       end
#       
#     end
#    end
#    
#    
#   
# end

# after(:all) do
#    ActiveRecord::Migrator.up('db/migrate')  #to the latest?
# end


# NOTE - when split into 2 files (up only), test repeatively one after another - totally green 
# NOTE - combine in this file to ensure reset & recreate tested ONCE in correct sequence - green
#ORIGINAL---- 
# describe ResetLibraryCatalogs do
#  
#   describe 'up' do
#      before do
# 	@migration='20171109075052'#'20171107050528' #'20171109075052' #'20171109053327'
# 	ActiveRecord::Migrator.migrate @migration
# 	puts "migrate later(create) (in order to DRop)"
#       end
#     
#     it 'drops books, accessions and booksearches tables' do
#       ResetLibraryCatalogs.up 
#       table_list=ActiveRecord::Base.connection.tables
#       table_list.should_not include("books")
#       table_list.should_not include("accessions")
#       table_list.should_not include("booksearches")
#     end
#   end
  
# #   describe 'down' do
# #     before do
# #       @prev_migration='20171109071718'
# #       ActiveRecord::Migrator.migrate @prev_migration
# #       puts "migrate current : "
# #     end
# #     
# #     it 'recreate books, accessions and booksearches tables' do
# # #       @migration='20171109071718'
# # #       ActiveRecord::Migrator.migrate @migration
# # #       puts "migrate current"
# #       ResetLibraryCatalogs.down
# #       table_list=ActiveRecord::Base.connection.tables
# #       table_list.should include("books")
# #       table_list.should include("accessions")
# #       table_list.should include("booksearches")
# #     end
# #   end
#   
# end
#------------------
#ORIGINAL2----
# describe RecreateLibraryCatalogs do
#   
#   describe 'up' do
#     before do
#       @prev_migration='20171109071718'
#       ActiveRecord::Migrator.migrate @prev_migration
#       puts "Run previous migration : drop tables (in order to REcreate) : "
#     end
#     
#     it 'recreate books, accessions and booksearches tables' do
#       RecreateLibraryCatalogs.up 
#       table_list=ActiveRecord::Base.connection.tables
#       table_list.should include("books")
#       table_list.should include("accessions")
#       table_list.should include("booksearches")
#     end
#   end
#   
# #   describe 'down' do
# #     before do
# # #       @prev_migration='20171109071718'
# # #       ActiveRecord::Migrator.rollback @prev_migration
# # #             puts "Rollback previous migration : recreate tables (in order to DRop) : "
# # 
# #       @migration='20171109075052'
# #       ActiveRecord::Migrator.migrate @migration
# #       puts "huhu"
# #     end
# #     
# #     it 'drops books, accessions and booksearches tables' do
# #       RecreateLibraryCatalogs.down
# #       table_list=ActiveRecord::Base.connection.tables
# #       table_list.should_not include("books")
# #       table_list.should_not include("accessions")
# #       table_list.should_not include("booksearches")
# #     end
# #   end
#   
# end
#------------------

# REF : https://blog.carbonfive.com/2011/01/27/start-testing-your-migrations-right-now/
# REF : http://deploymentzone.com/2013/01/13/testing-activerecord-migrations/
# REF : https://gist.github.com/semipermeable/1083203
# REF : https://stackoverflow.com/questions/36608902/conditional-filters-for-contexts-in-rspec
# REF : https://forum.shakacode.com/t/understanding-rspec-expect-and-change-syntax-in-the-context-of-ruby/219
# REF : https://stackoverflow.com/questions/13966022/rspec-expect-to-change-with-multiple-values

# before { @asset_defect.reported_by = nil }
#     it { should_not be_valid}
    
#   before(:each) do
#     @book = assign(:book, Book.create!(
#       :isbn => "1931-193-10991",
#       :title => "My Title",))
#   end