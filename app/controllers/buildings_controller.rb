class BuildingsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :set_building, only: [:destroy]

  # GET /buildings
  # GET /buildings.json
  def index
    # @buildings = Building.all

    hash = cookies[:city_hash]
    @city = City.find_by(city_hash: hash)
    @buildings = @city.buildings

    render json: @buildings, status: :ok
  end

  # POST /buildings/:buildingType
  def create
    hash = cookies[:city_hash]
    @city = City.find_by(city_hash: hash)

    unless @city
      render json: {error: "Can't find the City"}, status: :unprocessable_entity
    end

    if (params[:building_type] == 1)
      if (@city.stone.to_i > 10 && @city.wood.to_i > 10)
        @building = Building.new(collect_minute: 1, last_collect: Time.now, amount:10, resource_type: '1', city: @city)
          if @building.save
            render json: @building, status: :created, location: @building
          else
            render json: {error: @building.errors.first}, status: :unprocessable_entity
          end
      else
        render json: {error: "Not enough resources!"}, status: :unprocessable_entity
      end
    end

    if (params[:building_type] == 2)
      if (@city.stone.to_i > -1 && @city.wood.to_i > -1)
        @building = Building.new(collect_minute: 2, last_collect: Time.now, amount:10, resource_type: '1', city: @city)
          if @building.save
            render json: @building, status: :created, location: @building
          else
            render json: {error: @building.errors.first}, status: :unprocessable_entity
          end
      else
        render json: {error: "Not enough resources!"}, status: :unprocessable_entity
      end
    end

  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    unless @building
      render json: {error: "Can't find the City"}, status: :unprocessable_entity
    end

    @building.destroy

    render json: {notice: "Done!"}, :status => 204
  end

  # DELETE /buildings/collect/1
  def collect

    respond_to do |format|
      format.html { redirect_to buildings_url, notice: 'Building was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      hash = cookies[:city_hash]
      @city = City.find_by(city_hash: hash)
      @buildings = @city.buildings

      @building = Building.find(params[:id])
      unless @buildings.includes(@building)
        @building = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_params
      # params.require(:building).permit(:collect_minute, :last_collect, :amount, :resource_type)
      params.require(:building).permit(:building_type)
    end
end
