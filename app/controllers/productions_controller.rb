class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  # def index
  #   @start_date = params[:start_date]
  #   @end_date = params[:end_date]
  #   # Production.limit(20).includes(:issource, :invoices).order(:iss_source).each do |intermediary|
  #   #   @production = intermediary.policies.search_date(@start_date,@end_date).page(params[:page])
  #   # end
  #   @productions = Production.includes(:issource, :invoices).order(:iss_source).page(params[:page])
  # end

  def index
    @start_date =  (if params[:start_date].nil? then Date.current.beginning_of_month else  params[:start_date] end)
    @end_date =  (if params[:end_date].nil? then Date.current.end_of_month else  params[:end_date] end)
    # @productions = Production.includes(:policies).where('gipi_polbasic' => {acct_ent_date: @start_date..@end_date}).page(params[:page])
    # @productions = Production.limit(30).includes(:issource, :invoices).order(:iss_source).page(params[:page])
    # @productions = Production.order_by_issue_cd.filter_by_date(@start_date,@end_date).page(params[:page])
    productions1 = Production.order_by_issue_cd.filter_by_date(@start_date,@end_date)
    @productions = productions1.group_by{|e| [e.intm_name, e.intm_no, e.intm_type]}
    # @productions =  Kaminari.paginate_array(productions2.keys).page(params[:page])
    render "index2"
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @product = Production.find(params[:id])
  end

  # GET /productions/new
  def new
    @production = Production.new
  end

  # GET /productions/1/edit
  def edit
  end

  # POST /productions
  # POST /productions.json
  def create
    @production = Production.new(production_params)

    respond_to do |format|
      if @production.save
        format.html { redirect_to @production, notice: 'Production was successfully created.' }
        format.json { render :show, status: :created, location: @production }
      else
        format.html { render :new }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productions/1
  # PATCH/PUT /productions/1.json
  def update
    respond_to do |format|
      if @production.update(production_params)
        format.html { redirect_to @production, notice: 'Production was successfully updated.' }
        format.json { render :show, status: :ok, location: @production }
      else
        format.html { render :edit }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productions/1
  # DELETE /productions/1.json
  def destroy
    @production.destroy
    respond_to do |format|
      format.html { redirect_to productions_url, notice: 'Production was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production
      @production = Production.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_params
      params.require(:production).permit(:intermediary, :intm_no, :branch)
    end
end
