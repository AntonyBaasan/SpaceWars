class BuildingsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :set_building, only: [:destroy, :collect]

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

    if @city.blank?
      render json: {error: "Can't find the Ship"}, status: :unprocessable_entity and return
    elsif (@city.buildings.count >= @city.max_building_amount)
      render json: {error: "No space for more building"}, status: :unprocessable_entity and return
    end

    create_building_by_type params[:building_type], @city

  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    if @building.blank?
      render json: {error: "Wrong building"}, status: :unprocessable_entity
    else
      @building.destroy
      render json: {notice: "Deleted!"}, :status => 204
    end

  end

  # get /buildings/collect/1
  def collect
    if @building.blank?
      render json: {error: "Wrong building"}, status: :unprocessable_entity
    else

      # puts "@building.collect_minute.minutes.ago: "+@building.collect_minute.minutes.ago
      # puts "@building.last_collect.minutes.to_f: "+@building.last_collect.minutes.to_f.inspect
      puts "@building.last_collect: "+@building.last_collect.inspect
      puts "@city: "+@city.inspect

      # correct time
      if(@building.last_collect < @building.collect_minute.minutes.ago)
        @building.last_collect = Time.now
        @building.save


        if(@building.resource_type=='1')
          @city.stone = @city.stone + @building.amount
          notice = "Collected "+@building.amount.to_s+" minerals"
        elsif(@building.resource_type=='2')
          @city.wood = @city.wood + @building.amount
          notice = "Collected "+@building.amount.to_s+" energy"
        end
        @city.save

        render json: {notice: notice, amount: @building.amount }, :status => :ok
      else # time is not yes
        left_minute =  Time.at((@building.last_collect + @building.collect_minute*60 - Time.now)).utc.strftime("%M:%S") #=> "00:00"
        render json: {error: "Not yet generated! Have to wait " + left_minute}, :status => 406
      end

    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      hash = cookies[:city_hash]
      @city = City.find_by(city_hash: hash)
      @buildings = @city.buildings
      @building = Building.find(params[:id])

      # puts "@city: "+@city.inspect
      # puts "@buildings: "+@buildings.inspect
      # puts "@building: "+@building.inspect

      unless @buildings.includes(@building)
        @building = nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_params
      # params.require(:building).permit(:collect_minute, :last_collect, :amount, :resource_type)
      params.require(:building).permit(:building_type)
    end


    def time_diff(start_time, end_time)
      seconds_diff = (start_time - end_time).to_i.abs

      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600

      minutes = seconds_diff / 60

    end

    #
    def create_building_by_type typeId, city
      # if (params[:building_type] == 2)
      # end

      if (typeId == 1)
        required_stone = 20
        required_wood = 20
        newBuilding = Building.new(collect_minute: 1, last_collect: Time.now, amount:40, resource_type: '1', city: city)
      elsif (typeId == 2)
        required_stone = 20
        required_wood = 20
        newBuilding = Building.new(collect_minute: 1, last_collect: Time.now, amount:40, resource_type: '2', city: city)
      end

      if (city.stone.to_i < required_stone || @city.wood.to_i < required_wood)
        render json: {error: "Not enough resources!"}, status: :unprocessable_entity and return
      end

      @city.stone = @city.stone - required_stone
      @city.wood = @city.wood - required_wood

      City.transaction do
        if newBuilding.save && @city.save
          render json: newBuilding, status: :created and return
        else
          render json: {error: newBuilding.errors.first}, status: :unprocessable_entity and return
          raise ActiveRecord::Rollback
        end
      end


    end

end
