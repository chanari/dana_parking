class SendMailJob < ApplicationJob
  queue_as :default

  def perform(mail, password)
    AdminMailer.with(mail: mail, password: password).send_manager_info.deliver_later
  end
end
