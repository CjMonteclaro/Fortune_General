class PolicyReport < Prawn::Document
     def initialize(travels, start_date, end_date)
       super(:page_size => "A4", :page_layout => :landscape, :font => "Times-Roman")
       Prawn::Font::AFM.hide_m17n_warning = true
       font_size 10
       @travels = travels
       @start_date = start_date.to_date
       @end_date = end_date.to_date + 1.day
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
          [["Policy/Endorsement", "Insured", "Birthday", "Age", "Inception Date", "Expiry Date", "Destination", "Destination Class", "Duration", "Coverage Limit", "EndorsementText"]] +
          @travels = Policy.where(iss_date: @start_date..@end_date).where(line_code: "PA" ).where(subline_code: "TPS" ).where.not(polic_flag: ['4', '5']).includes(:assured, :item, :polgenin, :endttext, :accident_item).map do |policy|
             [policy.full_policy_no, policy.assured.assd_name,(policy.accident_item.acc_bday unless policy.accident_item.nil?),(policy.accident_item.acc_age unless policy.accident_item.nil?), policy.inc_date, policy.exp_date, (policy.accident_item&.acc_item_destination ), (policy.polgenin.travel_class unless policy.polgenin.nil?), (pluralize(policy.duration_date, 'day')), policy&.coverage, policy.endttext&.endt_txt]
       end
     end
   end
