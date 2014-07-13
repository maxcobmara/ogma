#not ready yet - 
#Failure/Error: before  { @user = FactoryGirl.create(:user) }
#NoMethodError:undefined method `encrypted_password=' for #<User:0x00000108ac65a8> # ./spec/models/user_spec.rb:5:in `block (2 levels) in <top (required)>

#require 'spec_helper'

#describe User do

  #before  { @user = FactoryGirl.create(:user) }

  #subject { @user }

  #it { should respond_to(:id) }
  #it { should respond_to(:staff_id) }
  #it { should respond_to(:login) }
  #it { should respond_to(:email) }
  #it { should respond_to(:password) }
  #it { should respond_to(:crypted_password) }  
  
  
  #it { should be_valid }
  
  #describe "when name is not present" do
    #before { @staff.name = "" }
    #it { should_not be_valid }
    #end

#describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  #end
  
  #end
# == Schema Information
#
# Table name: users
#
#  created_at                :datetime
#  crypted_password          :string(40)
#  email                     :string(100)
#  icno                      :string(255)
#  id                        :integer          not null, primary key
#  isstaff                   :boolean
#  login                     :string(40)
#  name                      :string(100)      default("")
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  salt                      :string(40)
#  staff_id                  :integer
#  student_id                :integer
#  updated_at                :datetime
#
