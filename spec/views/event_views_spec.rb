require 'spec_helper'

describe "event pages" do
  
  subject { page }
  

  describe "Staff Index page" do
    before  { @event = FactoryGirl.create(:event) }
    before { visit events_path }
    
    it { should have_selector('h1', text: 'Event List') }
    it { should have_selector('th', text: 'Start Date') }
    it { should have_selector('th', text: 'End Date') }
    it { should have_selector('th', text: 'Event Name') }
    it { should have_selector('th', text: 'Location') }
    it { should have_selector('th', text: 'Officiated By') }
    it { should have_selector('th', text: 'Created By')}
    it { should have_link(@event.eventname), href: event_path(@event) + "?locale=en" }
  end
end