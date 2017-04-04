class ChangeGipiPolgenin < ActiveRecord::Migration[5.0]
  def change
    change_column(:gipi_polgenin, :gen_info, :text)

  end

  def up
        change_column :gipi_polgenin, :gen_info, :text
  end
  def down
        change_column :gipi_polgenin, :gen_info, :long
  end
end
