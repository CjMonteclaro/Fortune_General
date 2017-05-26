class IntermediaryProductionsReport < Prawn::Document
     def initialize(policies, start_date, end_date)
       super(:page_size => "A4", :page_layout => :landscape, :font => "Times-Roman")
       Prawn::Font::AFM.hide_m17n_warning = true
       font_size 10
       @intermediary_productions = policies
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
          [["INTM","INTM_NO", "INTM_TYPE", "ISS_NAME", "PA", "AH", "CA", "EN", "FI", "MC", "MH", "MN", "SU", "AV", "PREM"]] +
          @intermediary_productions =  Policy.where(acct_ent_date: @start_date..@end_date).or(Policy.where(spld_acct_ent_date: @start_date..@end_date)).includes(:lines, :issource, :invoice, :intermediary).order('iss_cd').map do |policy|
             [policy.intermediary&.intm_name, policy.intermediary&.intm_no, policy.intermediary&.intm_type, policy.issource&.iss_name, policy.linecd_pa, policy.linecd_ah, policy.linecd_ca, policy.linecd_en, policy.linecd_fi, policy.linecd_mc, policy.linecd_mh, policy.linecd_mn, policy.linecd_su, policy.linecd_av, (policy.pre_amt * -1)]
       end
     end
   end
