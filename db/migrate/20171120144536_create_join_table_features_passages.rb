class CreateJoinTableFeaturesPassages < ActiveRecord::Migration[5.1]
  def change
    create_join_table :features, :passages do |t|
      t.index :feature_id
      t.index :passage_id
    end
  end
end
