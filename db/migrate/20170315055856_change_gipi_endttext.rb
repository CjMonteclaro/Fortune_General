class ChangeGipiEndttext < ActiveRecord::Migration[5.0]
   def change
     change_column(:gipi_endttext, :endt_text, :text)
  end

  def up
        change_column :gipi_endttext, :endt_text, :text
  end
  def down
        change_column :gipi_endttext, :endt_text, :long
  end
end
