class ConversationsController < ApplicationController
  
  before_action :authenticate_user!
  
  def new
  end
  
  def create
    recipients = User.where(id: conversation_params[:recipients])
    if conversation_params[:recipients].count > 1
      conversation = current_user.send_message(recipients, conversation_params[:body], conversation_params[:subject]).conversation
      flash[:success] =(t 'conversation.message_sent')#+conversation_params[:recipients].count.to_s
      redirect_to conversation_path(conversation)
    else
      flash[:error] =t 'conversation.select_recipient'
      redirect_to(:back)
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


  private

  def conversation_params
    params.require(:conversation).permit(:subject, :body,recipients:[])
  end
  
  def message_params
    params.require(:message).permit(:body, :subject, recipients:[])
  end
  
  
end
