class CreateArtifacts < ActiveRecord::Migration[5.1]
  def change
    create_table :artifacts do |t|
      t.belongs_to :project
      t.string :name
      t.string :filename

      t.timestamps
    end
  end
end
