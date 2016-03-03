class ConversationsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_staff_list, only: [:show, :new, :edit_draft]
  
  def new
    @subj=nil
    @bod=nil
    @recv=nil
  end
  
  def edit_draft
    @subj= Mailboxer::Conversation.where(id: params[:id]).first.subject  
    @bod= Mailboxer::Notification.where(id: Mailboxer::Conversation.where(id: params[:id]).first.receipts.first.notification_id).first.body
    
    # NOTE - RECIPIENT by group and / or person (in saved draft)
    #@recv= Mailboxer::Conversation.where(id: params[:id]).first.receipts.where(mailbox_type: 'inbox').pluck(:receiver_id)
    recv= Mailboxer::Conversation.where(id: params[:id]).first.receipts.where(mailbox_type: 'inbox').pluck(:receiver_id)
    included_group_ids=[]
    Group.all.each do |x|
      if x.listing.all? {|x| recv.include?(x)}
        included_group_ids << x.listing
        recv-= x.listing
      end
    end
    include_group=included_group_ids.join(",")
    @recv=recv+[include_group]
    
    notify_id=Mailboxer::Conversation.where(id: params[:id]).first.receipts.first.notification_id
    @uploaded_files=AttachmentUploader.where(msgnotification_id: notify_id)
  end
  
  def create
    #raise params.inspect
    # NOTE : retrieve recipient by group and / or person - same as FORWARD (refer Reply)
    all_recipients=conversation_params[:recipients]
    selected_recipients=[]
    for selected in all_recipients
      if selected.include?(",")
        selected_recipients+=selected.split(",")
      else
      selected_recipients << selected
      end
    end
    recipients = User.where(id: selected_recipients)

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
            flash[:notice]=(t 'conversation.message_sent')
            redirect_to conversation_path(conversation)
          #########
          else
            flash[:notice]=t 'conversation.file_uploaded_send_message'
            redirect_to action: 'edit_draft', id: conversation.id
          end  
          #########
        else
          notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: true)
          flash[:notice]=(t 'conversation.uploaded_invalid')
          redirect_to action: 'edit_draft', id: conversation.id
        end
      else
        flash[:success]=(t 'conversation.message_sent')
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
          flash[:notice]=(t 'conversation.message_sent')
          redirect_to conversation_path(conversation)
          #########
        else
          flash[:notice]=t 'conversation.file_uploaded_send_message'
          redirect_to action: 'edit_draft', id: conversation.id
        end  
        #########
      else
        flash[:notice]=(t 'conversation.uploaded_invalid')
        redirect_to action: 'edit_draft', id: conversation.id
      end
    else #no attachment
      Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: false) 
      flash[:success] =(t 'conversation.message_sent')
      redirect_to conversation_path(conversation)
    end
  end

  def show
    drafts_notify_ids=Mailboxer::Notification.where(draft: true).pluck(:id)
    @receipts = conversation.receipts_for(current_user)
    @receipts_rev=@receipts.where('notification_id NOT IN(?)', drafts_notify_ids)
    # mark conversation as read
    conversation.mark_as_read(current_user)
    #default forward text
    if@receipts.count == @receipts_rev.count 
      #w/o draft existance
      fw=@receipts.last.message
    else
      #with draft existance
      fw=Mailboxer::Notification.where(conversation_id: conversation.id).where(sender_id: current_user.id).last
    end
    if fw
      forward_body=fw.body
      
      # NOTE - RECIPIENT by Group and / or person - for use in FORWARD body
      #recipient=fw.receipts.where(mailbox_type: 'inbox').first.receiver.userable.name
      #recipient=Staff.where(id: User.where(id: fw.receipts.where(mailbox_type: 'inbox').pluck(:receiver_id)).pluck(:userable_id) ).pluck(:name).join(", ")
      receiver_ids=fw.receipts.where(mailbox_type: 'inbox').pluck(:receiver_id)
      included_group_name_person=""
      Group.all.each do |x|
        if x.listing.all? {|x| receiver_ids.include?(x)}
          members_name=Staff.where(id: User.where(id: x.listing).pluck(:userable_id)).pluck(:name).join(", ")
          included_group_name_person+=x.name+"("+members_name+") "
          receiver_ids-= x.listing
        end
      end
      recipient=included_group_name_person
      if receiver_ids.count > 0
        receivers=Staff.where(id: User.where(id: receiver_ids).pluck(:userable_id) ).pluck(:name).join(", ")
        recipient+=receivers
      end
    
      details=" ("+(t 'from')+":"+fw.sender.userable.name+", "+(t 'to2')+":"+recipient+", "+(t 'conversation.subject')+":"+fw.subject+", "+(t 'conversation.date')+":"+fw.created_at.strftime("%A, %b %d, %Y at %I:%M%p")+")   "+(t 'conversation.message').upcase+": "
      @forward_text=(t 'conversation.forwarded_message')+details+forward_body +" ---------------------------------------"
    end
  end
  
  def reply
    #raise params.inspect
    method=params["reply"]
    receipt_id=params["receiptid"]
    receipt=Mailboxer::Receipt.where(id: receipt_id).first
    if !message_params[:body].blank?
      if method=="1"
        #REPLY
        #current_user.reply_to_conversation(conversation, message_params[:body])
        if message_params[:notify_id].nil? #new form
          replied=current_user.reply_to_sender(receipt, message_params[:body]) 
          #notify_id=replied.conversation.receipts.last.notification_id ####
	  notify_id=replied.conversation.receipts.where(mailbox_type: 'sentbox').where(receiver_id: current_user.id).last.notification_id
        else #draft form
          notify_id=message_params[:notify_id].to_i
        end
        form_complete="1"
      else
        #FORWARD
        #recipients = User.where(id: message_params[:recipients]-[" "])
        # NOTE : retrieve recipient by group and / or person - same as Create
        all_recipients=message_params[:recipients]
        selected_recipients=[]
        for selected in all_recipients
          if selected.include?(",")
            selected_recipients+=selected.split(",")
          else
            selected_recipients << selected
          end
        end
        recipients = User.where(id: selected_recipients)
        ###
        if message_params[:recipients].count > 1 
          if message_params[:notify_id].nil? #new form
            # TODO - upon removal of conversation record, set pointer in DB (table Mailboxer::Conversation) to last record - ref: duplicates keys / violates related note
            # NOTE Forwarding Message - temp solution 27Feb2016 
            #1)send as new message first, 
            #2)then update conversation ID in Notification same as current conversation
            #3)remove newly created conversation
            #conversation2 = current_user.send_message(recipients, message_params[:body], conversation.subject).conversation
            #Mailboxer::Notification.where(conversation_id: conversation2.id).first.update_attributes(conversation_id: conversation.id)
            #Mailboxer::Conversation.where(id: conversation2.id).first.destroy
          
            conversation2 = current_user.send_message(recipients, message_params[:body], conversation.subject).conversation
            Mailboxer::Notification.where(conversation_id: conversation2.id).first.update_attributes(conversation_id: conversation.id)
            Mailboxer::Conversation.where(id: conversation2.id).first.destroy
            #notify_id=conversation.receipts.last.notification_id # NOTE above updated record, use conversation instead of conversation2 
            notify_id=conversation.receipts.where(mailbox_type: 'sentbox').where(receiver_id: current_user.id).last.notification_id
          else #draft form
            notify_id=message_params[:notify_id].to_i
          end
          form_complete="1"
        else
          #no recipient for forwarding selected
          form_complete="0"
        end
      end
    else
      flash[:notice]=(t 'conversation.message_required')
      redirect_to conversation_path(conversation)
    end
    if (!message_params[:body].blank?) && form_complete=="1"
      #########################################
      unless message_params[:data].nil? #when attachment exist
        newattach = AttachmentUploader.new
        newattach.data = message_params[:data]
        if newattach.valid?
          newattach.msgnotification_id=notify_id  
          newattach.save
          if params[:submit_button]
            #Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: false) if message_params[:notify_id] #send draft (with attachment)
	    Mailboxer::Notification.where(id: notify_id).first.update_attributes(:draft => false) if message_params[:notify_id] 
            flash[:notice]=(t 'conversation.message_replied_forwarded')
            redirect_to conversation_path(conversation)
          #########
          else
            #notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: true)  
	    notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(:draft => true)
            flash[:notice]=(t 'conversation.file_uploaded_send_message')
            redirect_to action: 'show', id: conversation.id
          end  
          #########
        else
          #notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: true) 
	  notify_todraft=Mailboxer::Notification.where(id: notify_id).first.update_attributes(:draft => true) 
          flash[:notice]=(t 'conversation.upload_invalid')
          redirect_to action: 'show', id: conversation.id
        end
      else #no attachment
        #Mailboxer::Notification.where(id: notify_id).first.update_attributes(draft: false) if message_params[:notify_id] 
	Mailboxer::Notification.where(id: notify_id).first.update_attributes(:draft => false) if message_params[:notify_id] 
        flash[:success] =(t 'conversation.message_replied_forwarded')
        redirect_to conversation_path(conversation)
      end
      ############################################
      #flash[:notice]=t 'conversation.message_replied'
      #redirect_to conversation_path(conversation)
    else
      if form_complete=="0"
        flash[:error]=t 'conversation.select_recipient_message'
      else
        flash[:notice]=t 'conversation.message_required'
      end
      redirect_to conversation_path(conversation) if (!message_params[:body].blank?)
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
  
  def set_staff_list
    user_ids=User.where(userable_type: 'Staff').where('userable_id is not null').order(userable_id: :asc).pluck(:id)
    staff_list=[]
    user_ids.each{|user_id|  staff_list << [Staff.joins(:users).where('users.id=?', user_id).first.name, user_id]}
    @staff_list=staff_list.sort
    @group_list=Group.all.collect{|x|[(t 'group.groups')+x.name, (x.members[:user_ids]-[""]).join(",") ]}
    @staff_list+=@group_list
  end

  def conversation_params
    params.require(:conversation).permit(:id, :subject, :body, :data, recipients:[])
  end
  
  def message_params
    params.require(:message).permit(:body, :subject, :data, :notify_id, recipients:[])
  end

end
