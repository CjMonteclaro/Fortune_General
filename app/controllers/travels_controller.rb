require 'will_paginate'
require 'csv'
class TravelsController < ApplicationController
  def index

  	start_date = params[:start_date]
    end_date = params[:end_date]
  	@travels = Policy.where(iss_date: start_date..end_date).where(line_code: "PA" ).where(subline_code: "TPS" ).where.not(polic_flag: ['4', '5']).includes(:assured, :item, :polgenin, :endttext, :accident_item).paginate(:page => params[:page], :per_page => 15)
  	@travels_csv = Policy.where(iss_date: start_date..end_date).where(line_code: "PA" ).where(subline_code: "TPS" ).where.not(polic_flag: ['4', '5']).includes(:assured, :item, :polgenin, :endttext, :accident_item)
     respond_to do |format|
     format.html
     format.csv { send_data @travels_csv.to_csv(start_date,end_date), filename: "travelpa-#{start_date}/#{end_date}.csv" }
     format.xls
     format.pdf do
        pdf = PolicyReport.new(@travels, start_date, end_date)
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
end
