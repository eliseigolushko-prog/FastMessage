class MessagesController < ApplicationController

  def create
    # Если в роутах указано param: :name, то в params будет :room_name
    @room = Room.find_by!(name: params[:room_name] || params[:room_id])
    @message = current_user.messages.build(message_params.merge(room: @room))

    if @message.save
      if @message.recipient.present?
        # 1. Отправляем получателю (в его личный поток в этой комнате)
        @message.broadcast_append_to(
          "room_#{@room.id}_user_#{@message.recipient_id}",
          target: "messages"
        )
        # 2. Отправляем отправителю (себе), чтобы сообщение появилось в чате
        @message.broadcast_append_to(
          "room_#{@room.id}_user_#{@message.user_id}",
          target: "messages"
        )
      else
        # Если получателя нет — шлем всем в общий поток комнаты
        @message.broadcast_append_to("room_#{@room.id}_messages", target: "messages")
      end

      # Очищаем форму у отправителя
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { room: @room, message: Message.new }) }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end
