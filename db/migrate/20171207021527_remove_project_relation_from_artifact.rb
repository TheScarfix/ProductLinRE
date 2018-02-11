class RemoveProjectRelationFromArtifact < ActiveRecord::Migration[5.2]
  def change
    remove_reference :artifacts, :project
  end
end
