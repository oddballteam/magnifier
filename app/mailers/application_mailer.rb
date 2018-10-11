# frozen_string_literal: true

# Base class from which mailers can inherit
#
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
