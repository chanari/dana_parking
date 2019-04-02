class AdminMailer < ApplicationMailer

  def send_manager_info
    @mail = params[:mail]
    @password = params[:password]
    mail(to: @mail, subject: 'Manager Login Information')
  end
end
