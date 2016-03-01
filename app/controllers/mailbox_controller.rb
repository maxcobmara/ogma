class MailboxController < ApplicationController
  
    before_action :authenticate_user!

    def inbox
      @inbox = mailbox.inbox.page(params[:page]).per(10)
      @active = :inbox
    end

    def sent
      @sent = mailbox.sentbox.page(params[:page]).per(10)
      @active = :sent
    end

    def trash
      @trash = mailbox.trash.page(params[:page]).per(10)
      @active = :trash
    end

end
