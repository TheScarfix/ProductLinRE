class RemoveFileFromPassagesAndArtifacts < ActiveRecord::Migration[5.2]
  def change
    remove_column :artifacts, :file, :file
    remove_column :passages, :file, :file
  end
end
