class CleanupOldMessagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Message.where('created_at < ?', 30.days.ago).destroy_all
  end
end
