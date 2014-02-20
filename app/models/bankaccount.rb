class Bankaccount < ActiveRecord::Base
  belongs_to :staff
  belongs_to :bank
end