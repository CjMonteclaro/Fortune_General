 class MotorsReport < Prawn::Document
      def initialize(policies, start_date, end_date)
        super(:page_size => "A4", :page_layout => :landscape, :font => "Times-Roman")
        Prawn::Font::AFM.hide_m17n_warning = true
        font_size 8
        @motor_policies = policies
        @motor_pol = policies
        @motor_po = policies
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
          font_size(8) {table transaction_rows }
       end

      def transaction_rows
           [["Policy No:", "Endorsement", "Issue Date", "Effective Date" , "Expiry Date", "Vehicle", "Peril Name", "Sum Insured", "Premium", "Premium Rate"]] +
           @motor_policies = Policy.where(acct_ent_date: @start_date..@end_date).where(line_code: "MC").or(Policy.where(spld_acct_ent_date: @start_date..@end_date).where(line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).map do |l|

            @motor_pol = l.perils&.where(line_code: "MC").each do |peril|
            @motor_po = peril.item_perils&.where(peril_cd: peril).each do |item|
              subtable = make_table([[peril&.shortname],[item&.proper_tsi], [item&.proper_prem], [item.proper_rate]])
              [l&.policy_no, l&.endorsemnt, l&.iss_date, l&.ef_date, l&.exp_date, l.vehicle&.vehicle_name, subtable ]
            end
           end
        end
      end

      # def sub_data(l)
      #   sub_data = sub_item_rows(l)
      #   make_table(sub_data) do
      #      columns(0).width = 200
      #     # columns(1).width = 100
      #     # columns(1).align = :right
      #      #columns(0).borders = []
      #   end
      # end
      #
      # def subtable_peril(l)
      #   l.perils.where(line_code: "MC").each do |peril|
      #     [peril&.shortname]
      #   end

      # def sub_item_rows(l)
      #  l.perils.where(line_code: "MC").map do |sub_item|
      #     [sub_item.shortname]
      #   end
      end
