module MailboxHelper
  
  def unread_messages_count
    # how to get the number of unread messages for the current user
    # using mailboxer
    
#     working solution - be4 26Oct2017
#     mailbox.inbox(:unread => true).count(:id, :distinct => true)
    
#     try workaround - 26Oct2017
#     Mailboxer::Receipt.where(receiver_id: current_user.id).inbox(:unread => true).count(:id, :distinct => true)
    Mailboxer::Receipt.where(receiver_id: current_user.id, mailbox_type: "inbox", is_read: false).count(:id, :distinct => true)
  end
end
