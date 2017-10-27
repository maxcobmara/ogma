require 'spec_helper'

describe Page do
  before  { @college = FactoryGirl.create(:college) }
  before  { @page = FactoryGirl.create(:page, :college_id => @college.id) }

  subject { @page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
#   it { should respond_to(:body) }
#   it { should respond_to(:admin) }
#   it { should respond_to(:parent_id) }
  it { should respond_to(:navlabel) }
  it { should respond_to(:position) }
#   it { should respond_to(:redirect) }
#   it { should respond_to(:action_name) }
#   it { should respond_to(:controller_name) }
  it { should respond_to(:college_id) }
#   it { should respond_to(:data) }
  
  it { should be_valid } 
#   do
#     college=FactoryGirl.create(:college)
#     apage=college.pages.first
#     expect(post).to_be_valid
#   end
  
end
