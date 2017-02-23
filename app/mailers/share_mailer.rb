class ShareMailer < ApplicationMailer

  def share_email(user, sitter, receiving_user)
    @user   = user
    @sitter = sitter
    @receiving_user = receiving_user
    @addurl  = url_for(controller: 'shares',
        action: 'create',
        receiving_email: @receiving_user.email,
        email: @sitter.email,
        name: @sitter.name,
        phone: @sitter.phone,
        ord: '0',
        can_drive: @sitter.can_drive,
        hourly_rate: @sitter.hourly_rate,
        host: 'www.sitterbot.io')
    mail(from: @user.email, to: @receiving_user.email, subject: '@user.name wants to share with you')
  end
end
