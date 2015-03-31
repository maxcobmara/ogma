module Spreadsheet2
  
   def self.open_spreadsheet(file) 
    case File.extname(file.original_filename) 
#       when ".csv" then Roo::Csv.new(file.path, nil, :ignore) 
#       when ".xls" then Roo::Excel.new(file.path, nil, :ignore) 
#       when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore) 
         #http://stackoverflow.com/questions/29189262/importing-excel-file-using-roo-error-supplying-packed-or-file-warning-as-s
         when ".csv" then Roo::Csv.new(file.path, packed: nil, file_warning: :ignore)
         when ".xls" then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
         when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}" 
    end
  end 
  
end