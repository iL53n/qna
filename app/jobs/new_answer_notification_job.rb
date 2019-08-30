class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotification.new.send_email(answer)
  end
end
