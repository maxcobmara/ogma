require 'csv' 
require 'mail'

namespace :mailer do
  path = "tmp/"
  
  desc "Daily Staff Late Book Mailer"
  task :late_daily_staff => :environment do
    puts "Searching for Late Books"
    
    @late_books = Librarytransaction.find_by_sql("
      SELECT s.name as name, s.coemail, b.title
      FROM librarytransactions lt
      LEFT JOIN staffs s on s.id=lt.staff_id
      LEFT JOIN accessions a on a.id=lt.accession_id
      LEFT OUTER JOIN books b on b.id=a.book_id
      WHERE lt.returned IS NULL
      AND s.coemail IS NOT NULL
      AND lt.returnduedate < current_date
      GROUP BY name, s.coemail, b.title;")
      
    @late_books.group_by(&:name).each do |person, transactions|
      mailto person
      for transaction in trasactions
    end
  end
  
  desc "Daily Student Late Book Mailer"
  task :late_daily_student => :environment do
    puts "Searching for Late Books"
  end
end
    
    
    
  