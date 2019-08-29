class Services::NewAnswerNotification
  def send_email(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.new_notification(subscription.user, answer).deliver_later
    end
  end
end