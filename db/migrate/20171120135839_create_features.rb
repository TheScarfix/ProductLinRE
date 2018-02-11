class CreateFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :features do |t|
      t.belongs_to :project
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
