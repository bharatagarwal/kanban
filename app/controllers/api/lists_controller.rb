class Api::ListsController < ApplicationController
  def create

    board = Board.find(params[:board_id])

    @list = List.new(list_params.merge({board_id: board.id}))

    if @list.save
      render :create, status: :created
    else
      @error = @list.errors.full_messages.join(', ')
      render 'api/shared/error', status: :unprocessable_entity
    end
  
  rescue ActiveRecord::RecordNotFound
    @error = "Invalid board id provided"
    render 'api/shared/error', status: :not_found
  end

  def update
    @list = List.find(params[:id])

    if @list.update_attributes(list_params)
      render :update
    else
      @error = @list.errors.full_messages.join(', ')
      render 'api/shared/error', status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    @error = "Invalid list id provided"
    render 'api/shared/error', status: :not_found
  rescue ActionController::ParameterMissing
    @error = "Title or position required"
    render 'api/shared/error', status: :unprocessable_entity
  end

  private

  def list_params
    params.require(:list).permit(:title)
  end
end
