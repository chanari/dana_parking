class HomeController < ApplicationController
  def parking
    @parkings = Parking.where(active: true).pluck(:id, :address)
  end

  def help
    @helper = Helper.new
  end

  def create_helper
    @helper = Helper.new help_params
    if @helper.save
      flash[:success] = 'Thành công.'
    else
      flash[:error] = 'Thất bại!'
    end
    redirect_to help_path
  end

  def price
    @size_1 = Floor.includes(:parking).where(size: '1')
    @size_2 = Floor.includes(:parking).where(size: '2')
    @size_3 = Floor.includes(:parking).where(size: '3')
  end

  def get_floors
    @floors = Floor.get_floors(params[:park_id], params[:block_size])
    respond_to do |format|
      if params[:park_id].nil? || params[:block_size].nil? || @floors.nil?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: @floors.as_json(except: [:created_at, :updated_at], include: { blocks: { only: [:id, :name], include: { parking_slots: { except: [:created_at, :updated_at, :block_id] }} }}), status: :ok }
      end
    end
  end

  private
  def help_params
    params.require(:helper).permit(:name, :email, :phone, :content)
  end
end
