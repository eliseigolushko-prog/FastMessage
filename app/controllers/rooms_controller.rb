class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @room, notice: 'Комната создана'
    else
      render :new
    end
  end

  def new
    @room = Room.new
  end

  def index
    @rooms = Room.all
  end

  def show
    # Ищем по полю name, так как мы договорились об уникальных именах
    @room = Room.find_by!(name: params[:name])
    @message = Message.new
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
