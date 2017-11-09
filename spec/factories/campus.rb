FactoryGirl.define do
  
  # Events  
  factory :event do
    sequence(:eventname) { |n| "eventname_#{n}" }
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    location {"location_name"}
    association :staff, factory: :basic_staff
    officiated {"random name"}
    participants {"random participant"}
  end
  
  factory :document do
    sequence(:serialno) { |n| "serial_#{n}" }
    sequence(:refno) { |n| "refno_#{n}" }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:from) { |n| "from_#{n}" }
    distribution_type 1
    category { Array(1..5).sample }
    association :college, factory: :college
    association :stafffilled, factory: :basic_staff
#     association :preparedby, factory: :basic_staff
#     association :cc1staff, factory: :basic_staff
#     association :cofile, factory: :cofile

#     ref: https://robots.thoughtbot.com/aint-no-calla-back-girl
    after(:create) {|document| create(:circulation, document: document)}
  end
  
  factory :circulation do
    association :staff, factory: :basic_staff
    association :document, factory: :document
  end
  
  factory :cofile do
    sequence(:name) { |n| "cofile_name_#{n}" }
    location 1
    association :owner, factory: :basic_staff
  end
  
  factory :address_book do
    sequence(:name) { |n| "external_co_#{n}" }
  end

  factory :bulletin do
    headline {"Headline"}
    content {"this is content"}
    association :staff, factory: :basic_staff
    publishdt {Time.at(rand * Time.now.to_f)}
  end
  
  factory :college do
     code "amsas"
     name "Kolej Satu"
     data {{ foo: "foobar", baz: "baff" }}
   end
   
  factory :page do
    name {"home"}
    title {"Homepage"}
    association :college, factory: :college
    navlabel {"aaa"}
    position 1
#     c=Page.create(name: 'about', title: 'About', navlabel: 'aaa', position: 1)
  end
  
  factory :group do
    sequence(:name) {|n| "Some Name #{n}"}
    description {"Some Description"}
    members {{user_ids: ["1", "2", "3"]}}
    association :college, factory: :college
    data {"Some string" }
  end
  
  #Each msg must contains: 1)conversation, 2)notification, 3)sender_mailboxer & 4)receiver_mailboxer
  factory :mailboxer_conversation, :class => "Mailboxer::Conversation" do
    sequence(:subject) {|n| "Subject #{n}"}
    after(:create) {|mailboxer_conversation| create(:mailboxer_notification, conversation_id: mailboxer_conversation.id)}
  end
  
  factory :mailboxer_notification, :class => "Mailboxer::Notification" do
    type {"Mailboxer::Message"}
    body{"Some string"}
    sequence(:subject) {|n| "Subject #{n}"}
    association :sender, factory: :staff_user #original sender (first) (sender_type="User" & sender_id=user.id)
    draft false
    global false
    after(:create) {|mailboxer_notification| create(:receiver_mailboxer, notification_id: mailboxer_notification.id)}
    after(:create) {|mailboxer_notification| create(:sender_mailboxer, notification_id: mailboxer_notification.id, receiver: mailboxer_notification.sender)}
  end
  
  factory :mailboxer_receipt, :class => "Mailboxer::Receipt" do    
    is_read {rand(2) == 1}
    trashed false # {rand(2) == 1}
    deleted false #{rand(2) == 1}
    association :receiver, factory: :staff_user #(receiver_type="User" & receiver_id=user.id)
    
    factory :sender_mailboxer do
      mailbox_type {"sentbox"}
    end
    
    factory :receiver_mailboxer do
      mailbox_type {"inbox"}
    end
  end
  
  factory :mailbox do
  end
  
  factory :visitor do
    sequence(:name) {|n| "Visitor #{n}"}
    icno {(0...12).map {rand(10).to_s}.join }
    association :rank, factory: :rank
    association :title, factory: :title
    association :college, factory: :college
    association :address_book, factory: :address_book
    corporate {true}
    sequence(:department) {|n| "Department #{n}"}
    phoneno {(0...10).map {rand(10).to_s}.join }
    hpno {(0...10).map {rand(10).to_s}.join }
    email { |n| "visitor#{n}@example.com" }
    expertise {"My expertise"}
  end
  
end
