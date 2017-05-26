 class IntermediaryReport < Prawn::Document
      def initialize(intermediaries, search)
        super(:page_size => "A4", :page_layout => :landscape, :font => "Times-Roman")
        Prawn::Font::AFM.hide_m17n_warning = true
        font_size 10
        @intermediaries = intermediaries
        @search = search
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
           [["Intermediary No", "Parent Intermediary No","Intermediary Name", "Status", "Remarks" ]] +
           @intermediaries = Intermediary.all.map do |l|
              [l.no, l.parnt_intm_no, l.name, l.show_status, l.rem ]
        end
      end
    end
