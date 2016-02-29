class ConversationsController < ApplicationController
  
  before_action :authenticate_user!
  
  def new
  end
  
  def edit_draft
  end
  
  def create
    #raise params.inspect
    recipients = User.where(id: conversation_params[:recipients])
    if conversation_params[:recipients].count > 1
      conversation = current_user.send_message(recipients, conversation_params[:body], conversation_params[:subject]).conversation
      notify_id=conversation.receipts.first.notification_id
      unless conversation_params[:data].nil?  #when upload exist
        newattach = AttachmentUploader.new
        newattach.data = conversation_params[:data]
        if newattach.valid?
          newattach.msgnotification_id=notify_id  
          newattach.save
          if params[:submit_button]
            flash[:notice]="mesej sent c/w attachment"
            redirect_to conversation_path(conversation)
          #########
          else
            flash[:notice]="Selected file uploaded, add another file or click 'Send Message' to submit message!"
            redirect_to action: 'edit_draft', id: conversation.id
          end  
          #########
        else
          notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: true)
          flash[:notice]="Attach file is invalid"
          redirect_to action: 'edit_draft', id: conversation.id
        end
      else
        flash[:success] =(t 'conversation.message_sent')
        redirect_to conversation_path(conversation)
      end   
    else
      flash[:error] =t 'conversation.select_recipient'
      redirect_to(:back) #no saving occured at all (body include but recipient is blank, data will lost) - provide checker in New form instead?
    end
  end
  
   def send_draft
     #raise params.inspect
     conversation = Mailboxer::Conversation.where(id: params[:id]).first
     notify_id=conversation.receipts.first.notification_id
     unless conversation_params[:data].nil? #when attachment exist
       newattach = AttachmentUploader.new
       newattach.data = conversation_params[:data]
       if newattach.valid?
         newattach.msgnotification_id=notify_id  
         newattach.save
         if params[:submit_button]
           Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: false) #send draft (with attachment)
           flash[:notice]="mesej sent c/w attachment"+"yea yea"
           redirect_to conversation_path(conversation)
         #########
         else
           flash[:notice]="Selected file uploaded, add another file or click 'Send Message' to submit message! yea yea"
           redirect_to action: 'edit_draft', id: conversation.id
         end  
         #########
       else
         flash[:notice]="Attach file is Invalid yea yea"
         redirect_to action: 'edit_draft', id: conversation.id
       end
     else #no attachment
       Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: false) 
       flash[:success] =(t 'conversation.message_sent')+"yea yea"
       redirect_to conversation_path(conversation)
     end
   end

  def show
    @receipts = conversation.receipts_for(current_user)
    # mark conversation as read
    conversation.mark_as_read(current_user)
  end
  
  def reply
    method=params["reply"]
    receipt_id=params["receiptid"]
    receipt=Mailboxer::Receipt.where(id: receipt_id).first
    if method=="1"
      if (!message_params[:body].blank?)
        #current_user.reply_to_conversation(conversation, message_params[:body])
        current_user.reply_to_sender(receipt, message_params[:body])
        flash[:notice]=t 'conversation.message_replied'
        redirect_to conversation_path(conversation)
      else
        flash[:notice]=t 'conversation.message_required'
        redirect_to conversation_path(conversation)
      end
    else
      #raise params.inspect
      recipients = User.where(id: message_params[:recipients]-[" "])
      if message_params[:recipients].count > 1 && !message_params[:body].blank?

        # TODO - upon removal of conversation record, set pointer in DB (table Mailboxer::Conversation) to last record - ref: duplicates keys / violates related note
        # NOTE Forwarding Message - temp solution 27Feb2016 
        #1)send as new message first, 
        #2)then update conversation ID in Notification same as current conversation
        #3)remove newly created conversation
        conversation2 = current_user.send_message(recipients, message_params[:body], conversation.subject).conversation
        Mailboxer::Notification.where(conversation_id: conversation2.id).first.update_attributes(conversation_id: conversation.id)
        Mailboxer::Conversation.where(id: conversation2.id).first.destroy

        flash[:notice] =(t 'conversation.message_forwarded')
        redirect_to conversation_path(conversation)
      else
        flash[:error] =t 'conversation.select_recipient_message'
        redirect_to(:back)
      end
    end
  end
  

  def trash
    conversation.move_to_trash(current_user)
    redirect_to mailbox_inbox_path
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to mailbox_inbox_path
  end

#   def upload
#      @attachment_uploader= AttachmentUploader.new
#      if params[:attachment_uploader] && params[:attachment_uploader][:data].present?
#        @attachment_uploader.data = params[:attachment_uploader][:data]
#         #@attachment_uploader.msgnotification_id=conversation.receipts.first.notification_id 
#         #if @attachment_uploader.valid?
#         if @attachment_uploader.save
#           flash[:notice]="FIle uploaded"
#           redirect_to upload_conversations_path
#         else
#           flash[:notice]="Attach file not valid"
#           render "new"
#         end
#      end
#   end
  
  private

  def conversation_params
    params.require(:conversation).permit(:id, :subject, :body, :data, recipients:[])
  end
  
  def message_params
    params.require(:message).permit(:body, :subject, recipients:[])
  end
  
  
end
