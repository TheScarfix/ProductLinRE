class CreateJoinTableArtifactsProjects < ActiveRecord::Migration[5.2]
  def change
    create_join_table :artifacts, :projects do |t|
      t.index :artifact_id
      t.index :project_id
    end
  end
end
