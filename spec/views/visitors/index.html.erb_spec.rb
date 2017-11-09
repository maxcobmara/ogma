require 'rails_helper'

RSpec.describe "campus/visitors/index", :type => :view do
  before(:each) do
#     @visitor1=FactoryGirl.create(:visitor)
#     @visitor2=FactoryGirl.create(:visitor)
  
#     assign(:visitors, [
#       Visitor.create!(
#         :name => "Name",
#         :icno => "Icno",
#         :rank_id => 1,
#         :title_id => 1,
#         :department => "Department",
#         :phoneno => "Phoneno",
#         :hpno => "Hpno",
#         :email => "Email",
#         :expertise => "Expertise"
#       ),
#       Visitor.create!(
#         :name => "Name",
#         :icno => "Icno",
#         :rank_id => 1,
#         :title_id => 1,
#         :department => "Department",
#         :phoneno => "Phoneno",
#         :hpno => "Hpno",
#         :email => "Email",
#         :expertise => "Expertise"
#       )
#     ])
    
    @rank=FactoryGirl.create(:rank)
    @title=FactoryGirl.create(:title)
    @college=FactoryGirl.create(:college)
    @address_book=FactoryGirl.create(:address_book)
    @visitor1=FactoryGirl.create(:visitor, name: "Visitor 1", icno: "123456789101", rank_id: @rank.id, title_id: @title.id, college_id: @college.id, corporate: true, address_book_id: @address_book.id, phoneno: "1234567891", hpno: "1234567890", email:  "visitor1@example.com", expertise: "My Expertise")
    @visitor2=FactoryGirl.create(:visitor, name: "Visitor 1", icno: "123456789101", rank_id: @rank.id, title_id: @title.id, college_id: @college.id, corporate: false, department: "Department1", phoneno: "1234567891", hpno: "1234567890", email:  "visitor1@example.com", expertise: "My Expertise")
    
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @search=Visitor.search(params[:q])
    @visitors=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of visitors" do
#     render
    render :template => 'campus/visitors/index', :layout => false
    assert_select "tr>td", :text => "#{formatted_mykad(@visitor1.icno)}".to_s, :count => 2
    assert_select "tr>td", :text => "#{@visitor1.visitor_with_title_rank}".to_s, :count => 2
    assert_select "tr>td", :text => "#{@address_book.name}".to_s, :count => 1
    expect(rendered).to match(/Department1/)
  end
end
