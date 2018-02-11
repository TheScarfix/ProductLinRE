class AddFileToArtifact < ActiveRecord::Migration[5.1]
  def change
    add_column :artifacts, :file, :string
  end
end
