require 'csv' 
require 'mail'

namespace :library do
  path = "tmp/"
  
  desc "Daily Staff Late Book Mailer"
  task :late_daily_staff => :environment do
    puts "Searching for Late Books"
    
    @late_books = Librarytransaction.find_by_sql("
      SELECT s.name as name, s.coemail as email, b.title as books
      FROM librarytransactions lt
      LEFT JOIN staffs s on s.id=lt.staff_id
      LEFT JOIN accessions a on a.id=lt.accession_id
      LEFT OUTER JOIN books b on b.id=a.book_id
      WHERE lt.returned IS NULL
      AND s.coemail IS NOT NULL
      AND lt.returnduedate < current_date
      GROUP BY name, email, books;")
    
      
    @late_books.group_by(&:email).each do |email, transactions|
      LibraryMailer.library_staff_late_reminder(email, transactions).deliver
      for transaction in transactions
        puts transaction.books
      end
    end
  end
  
  desc "Daily Student Late Book Mailer"
  task :late_daily_student => :environment do
    puts "Searching for Late Books"
    
    @late_books = Librarytransaction.find_by_sql("
      SELECT s.name as name, s.semail as email, b.title as books
      FROM librarytransactions lt
      LEFT JOIN students s on s.id=lt.student_id
      LEFT JOIN accessions a on a.id=lt.accession_id
      LEFT OUTER JOIN books b on b.id=a.book_id
      WHERE lt.returned IS NULL
      AND s.semail IS NOT NULL
      AND lt.returnduedate < current_date
      GROUP BY name, email, books;")
      
    @late_books.group_by(&:email).each do |email, transactions|
      LibraryMailer.library_student_late_reminder(email, transactions).deliver
      for transaction in transactions
        puts transaction.books
      end
    end
  end
  
  desc "Daily Visitor Late Marine Document Mailer"
  task :late_daily_visitor => :environment do
    puts "Searching for Late Marine Documents"
    @late_books=Librarytransaction.marine_docs_transactions.where(returned: [false, nil]).where('returnduedate <?', Date.today.yesterday)
    @late_books.group_by{|x|Visitor.find(x.loaner.to_i).email}.each do |email, transactions|
      LibraryMailer.library_visitor_late_reminder(email, transactions).deliver
      for transaction in transactions
        repo_id=0
        Repository.digital_library.each{|u|repo_id=u.id if u.code==transaction.digital_document}
        document=Repository.find(repo_id).title
        puts document
      end
    end
  end
  
  task :student => [:late_daily_student]
  task :staff  =>  [:late_daily_staff]
  task :visitor => [:late_daily_visitor]
  task :all     => [:late_daily_student, :late_daily_staff, :late_daily_visitor]
end
    
    
    
  