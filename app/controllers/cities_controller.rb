class CitiesController < ApplicationController
  before_action :set_city #, only: [:show, :edit, :update, :destroy, :fighters_list]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.select(:id, :name, :locked, :stone, :wood, :win, :lose, :population).order(population: :desc).limit(30)
    @city_hash = cookies[:city_hash]
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    redirect_to_default_page_if_no_city("First create the ship")
  end

  # GET /cities/new
  def new
    if(@city.blank?)
      @city = City.new
    else
      respond_to do |format|
        format.html { redirect_to city_url(@city), notice: "" }
        format.json { head :no_content }
      end
    end

  end

  # GET /cities/1/edit
  def edit
    redirect_to_default_page_if_no_city ("Can't find your ship")
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)
    @city.city_hash = generate_unique_hash
    cookies[:city_hash] = @city.city_hash
    cookies[:city_hash] = { :value => @city.city_hash, :expires => 168.hour.from_now }

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /cities/fighterslist/
  def fighters_list
    # @cities = City.select(:id,:name).sample(20)
    @cities = City.select(:id,:name, :population).where().not(id: @city.id).limit(20).order("RANDOM()")
    # @cities(@city.id)
    render json: @cities, status: :ok
  end

  # GET /cities/fight/:eneny_id
  def fight
    if(@city.blank?)
      render json: {error: "Can't find correct data!"}, status: :unprocessable_entity and return
    elsif(@city.last_fight_date > 3.minutes.ago)
      left_minute =  Time.at((@city.last_fight_date + 3*60 - Time.now)).utc.strftime("%M:%S") #=> "00:00"
      render json: {error: "You are not recovered from previous fight. "+left_minute+" left until recovery!"}, status: :unprocessable_entity and return
    end

    @enemyCity = City.find(params[:enemy_id])
    if @enemyCity.blank?
      render json: {error: "Can't find current enemy!"}, status: :unprocessable_entity and return
    end

    myAttack,myDefence = @city.units.sum(:attack, :defence)
    enemyAttack = @enemyCity.units.sum(:attack)

    winPopulationChange = rand(100..150)
    losePopulationChange = rand(40..60)
    populationChange = 0

    if myAttack > enemyAttack
      notice = "You won"
      @city.last_fight_date = Time.now
      # change stat
      @city.win = @city.win + 1
      @enemyCity.lose = @enemyCity.lose + 1
      # change buildings
      damageCity @enemyCity
      # delete units
      #@enemyCity.units.delete_all #lost player will not know about his lost. Have to add later when player can see history
      # add experience
      @city.population = @city.population + winPopulationChange
      @enemyCity.population = @enemyCity.population + losePopulationChange
      populationChange = winPopulationChange
    else
      notice = "You lost"
      # change stat
      @city.lose = @city.lose + 1
      @enemyCity.win = @enemyCity.win + 1
      # change stat
      damageCity @city
      # delete units
      @city.units.delete_all
      # add experience
      @city.population = @city.population + losePopulationChange
      @enemyCity.population = @enemyCity.population + winPopulationChange
      populationChange = losePopulationChange
    end

    City.transaction do
      if @city.save! && @enemyCity.save!
        render json: {notice: notice, population: populationChange}, status: :ok and return
      else
        render json: {error: "Fight cancellad"}, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end

  end


  # DELETE /cities/1
  # DELETE /cities/1.json
  # def destroy
  #
  #   if(!@city)
  #     notice = 'City is already deleted.'
  #   else
  #     notice = 'City was successfully destroyed.'
  #     @city.destroy
  #     cookies.delete(:city_hash)
  #   end
  #
  #   respond_to do |format|
  #     format.html { redirect_to cities_url, notice: notice }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      # @city = City.find(params[:id])
      hash = cookies[:city_hash]
      @city = City.find_by(city_hash: hash)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :locked, :city_type)
    end

    def generate_unique_hash
      enum = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(15)
      enum.next.join
    end

    # redirect to no city page
    def redirect_to_default_page_if_no_city(note)
      if(@city.blank?)
        respond_to do |format|
          format.html { redirect_to new_city_url, notice: note }
          format.json { head :no_content }
        end
      end
    end

    def damageCity city
      buildings = city.buildings.offset(3)
      buildings.each { |b| b.destroy }
    end
end
