class RemoveJoinArtifactsProjects < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :artifacts, :projects
  end
end
