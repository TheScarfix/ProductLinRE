class CreatePassages < ActiveRecord::Migration[5.1]
  def change
    create_table :passages do |t|
      t.belongs_to :artifact
      t.string :filename

      t.timestamps
    end
  end
end
