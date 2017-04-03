 class PolicyReport1 < Prawn::Document
      def initialize(policies, start_date, end_date)
        super(:page_size => "A4", :page_layout => :landscape, :font => "Times-Roman")
        Prawn::Font::AFM.hide_m17n_warning = true
        font_size 10
        @policies = policies
        @start_date = start_date
        @end_date = end_date
        render_header
        render_body
       end

       private

       def render_header
        filename = "#{Rails.root}/fgen.jpg"
        image filename, :width => 500, :height => 70, :position => :left
       end

       def render_body
          move_down 20
          font_size(8) {table transaction_rows}
       end

       def transaction_rows
           [["Policy No:", "Assured Name",  "Intermediary", "TSI Amount", "Premium Amount"]] +
           @policies =  Policy.where(acct_ent_date: @start_date..@end_date).or(Policy.where(spld_acct_ent_date: @start_date..@end_date)).includes(:intermediary, :assured).order('iss_cd').map do |l|
              [l.full_policy_no, l.assured.assd_name,(l.intermediary.int_name unless l.intermediary.nil?), l.ts_amt, l.pre_amt]
        end
      end
    end
