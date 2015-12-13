class UnitsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_action :set_unit, only: [:destroy]

  # GET /units
  # GET /units.json
  def index
    hash = cookies[:city_hash]
    @city = City.find_by(city_hash: hash)
    @units = @city.units

    render json: @units, status: :ok
  end

  # POST /units
  # POST /units.json
  def create
    hash = cookies[:city_hash]
    @city = City.find_by(city_hash: hash)

    if @city.blank?
      render json: {error: "Can't find the City"}, status: :unprocessable_entity and return
    elsif (@city.units.count >= @city.max_army_amount)
      render json: {error: "Unit amount limit exceeded"}, status: :unprocessable_entity and return
    end

    create_unit_by_type params[:unit_type], @city

  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    if @unit.blank?
      render json: {error: "Can't delete unit"}, status: :unprocessable_entity
    else
      @unit.destroy
      render json: {notice: "Deleted!"}, :status => 204
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      hash = cookies[:city_hash]
      @city = City.find_by(city_hash: hash)
      @units = @city.units
      @unit = Unit.find(params[:id])

      unless @units.includes(@unit)
        @unit = nil
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:name, :type, :attack, :defence)
    end


  def create_unit_by_type typeId, city

    puts "typeId: "+typeId.to_s

    if (typeId == 1)
      required_stone = 100
      required_wood = 100
      newUnit = Unit.new(name: "type1", unit_type: typeId, attack:10, defence: 10, city: city)
    elsif (typeId == 2)
      required_stone = 150
      required_wood = 150
      newUnit = Unit.new(name: "type2", unit_type: typeId, attack:10, defence: 10, city: city)
    elsif (typeId == 3)
      required_stone = 300
      required_wood = 500
      newUnit = Unit.new(name: "type3", unit_type: typeId, attack:10, defence: 10, city: city)
    elsif (typeId == 4)
      required_stone = 1000
      required_wood = 800
      newUnit = Unit.new(name: "type4", unit_type: typeId, attack:10, defence: 10, city: city)
    end

    if newUnit.blank?
      render json: {error: "Unknown unit type!"}, status: :unprocessable_entity and return
    else
      unless (@city.stone.to_i > required_stone && @city.wood.to_i > required_wood)
        render json: {error: "Not enough resources!"}, status: :unprocessable_entity and return
      end

      if newUnit.save
        render json: newUnit, status: :created, location: newUnit and return
      else
        render json: {error: newUnit.errors.first}, status: :unprocessable_entity and return
      end
    end

    render json: {error: "Unknown error"}, status: :unprocessable_entity and return


  end
end
