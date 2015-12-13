class BuildingsController < ApplicationController
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

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        format.json { render json: @building, status: :created, location: @building }
      else
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      format.html { redirect_to buildings_url, notice: 'Building was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      params.require(:building).permit(:collect_minute, :last_collect, :amount, :resource_type, :city)
    end
end
