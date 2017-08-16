class TravelpasController < ApplicationController
  before_action :set_travelpa, only: [:show, :edit, :update, :destroy]

  # GET /travelpas
  # GET /travelpas.json
  def index
  	start_date = params[:start_date]
    end_date = params[:end_date]
  	@travels = Policy.travel_search_date(start_date,end_date).paginate(:page => params[:page], :per_page => 15)
  	@travels_csv = Policy.travel_search_date(start_date,end_date)
     respond_to do |format|
     format.html
     format.csv { send_data @travels_csv.to_csv(start_date,end_date), filename: "travelpa-#{start_date}/#{end_date}.csv" }
     format.xls
     format.pdf do
        pdf = PolicyReport.new(@travels_csv, start_date, end_date)
        send_data pdf.render,filename: "TravelPA.pdf",
                            type: "application/pdf"
                            # ,
                            # disposition: "inline"
    end
  end
  end

  def show
    @travel_policy = Policy.find(params[:id])
  end


  # GET /travelpas/new
  def new
    @travelpa = Policy.new
  end

  # GET /travelpas/1/edit
  def edit
  end

  # POST /travelpas
  # POST /travelpas.json
  def create
    @travelpa = Policy.new(travelpa_params)

    respond_to do |format|
      if @travelpa.save
        format.html { redirect_to @travelpa, notice: 'Travelpa was successfully created.' }
        format.json { render :show, status: :created, location: @travelpa }
      else
        format.html { render :new }
        format.json { render json: @travelpa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /travelpas/1
  # PATCH/PUT /travelpas/1.json
  def update
    respond_to do |format|
      if @travelpa.update(travelpa_params)
        format.html { redirect_to @travelpa, notice: 'Travelpa was successfully updated.' }
        format.json { render :show, status: :ok, location: @travelpa }
      else
        format.html { render :edit }
        format.json { render json: @travelpa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /travelpas/1
  # DELETE /travelpas/1.json
  def destroy
    @travelpa.destroy
    respond_to do |format|
      format.html { redirect_to travelpas_url, notice: 'Travelpa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_travelpa
      @travelpa = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travelpa_params
      params.fetch(:travelpa, {})
    end
end
