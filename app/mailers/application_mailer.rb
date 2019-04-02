class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.GMAIL_USERNAME
  layout 'mailer'
end
