class CreateJoinTableArtifactsFeatures < ActiveRecord::Migration[5.1]
  def change
    create_join_table :artifacts, :features do |t|
      t.index :artifact_id
      t.index :feature_id
    end
  end
end
