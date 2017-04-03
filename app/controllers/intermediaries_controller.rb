require 'csv'
class IntermediariesController < ApplicationController
  before_action :set_intermediary, only: [:show, :edit, :update]


  # GET /intermediaries
  # GET /intermediaries.json
  def index
    search = params[:search]
    stats = params[:stats]
    @intermediaries = Intermediary.search(params[:search]).paginate(:page => params[:page], :per_page => 20)
    @intermediaries_csv = Intermediary.all
    respond_to do |format|
    format.html
    format.csv { send_data @intermediaries_csv.to_csv(stats), filename: "intermediary.csv" }
    format.xls
    format.pdf do
       pdf = IntermediaryReport.new(@intermediaries, search)
       send_data pdf.render,filename: "intermediary.pdf",
                           type: "application/pdf"
                           # ,
                           # disposition: "inline"
             end
           end
          end

  # GET /intermediaries/1
  # GET /intermediaries/1.json
  def show
    @intermediary = Intermediary.find(params[:id])
  end

  # GET /intermediaries/new
  def new
    @intermediary = Intermediary.new
  end

  # GET /intermediaries/1/edit
  def edit
  end

  # POST /intermediaries
  # POST /intermediaries.json
  def create
    @intermediary = Intermediary.new(intermediary_params)

    respond_to do |format|
      if @intermediary.save
        format.html { redirect_to @intermediary, notice: 'Intermediary was successfully created.' }
        format.json { render :show, status: :created, location: @intermediary }
      else
        format.html { render :new }
        format.json { render json: @intermediary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /intermediaries/1
  # PATCH/PUT /intermediaries/1.json
  def update
    respond_to do |format|
      if @intermediary.update(intermediary_params)
        format.html { redirect_to @intermediary, notice: 'Intermediary was successfully updated.' }
        format.json { render :show, status: :ok, location: @intermediary }
      else
        format.html { render :edit }
        format.json { render json: @intermediary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intermediaries/1
  # DELETE /intermediaries/1.json
  def destroy
    @intermediary.destroy
    respond_to do |format|
      format.html { redirect_to intermediaries_url, notice: 'Intermediary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intermediary
      @intermediary = Intermediary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def intermediary_params
      params.require(:intermediary).permit(:name, :no, :nickn, :email, :cell_no, :phon_no, :faxno, :homeadd, :bday, :address, :tin_no, :bill_add, :contact_person, :int_type_desc, :issuing_office, :effi_date, :exp_date, :license_no, :stat, :rem, :parnt_intm_no, :iss_source, :cointm_type, :corp, :wtaxrate, :invat_rate, :paymnt, :parnt_intm_tin_sw, :spec_rate)
    end
end
