# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'gqs@hexlet.com'
  layout 'mailer'
end
