class StaffGrade < ActiveRecord::Base
    has_many  :positions
end