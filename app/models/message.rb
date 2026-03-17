class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :recipient, class_name: "User", optional: true

  after_create_commit -> {
    broadcast_append_to "room_#{room.id}_messages",
    target: "messages",
    locals: { user: user }
  }
  after_destroy_commit -> { broadcast_remove_to "room_#{room.id}_messages" }
end
