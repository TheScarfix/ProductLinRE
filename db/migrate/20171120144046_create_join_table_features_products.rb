class CreateJoinTableFeaturesProducts < ActiveRecord::Migration[5.1]
  def change
    create_join_table :features, :products do |t|
      t.index :feature_id
      t.index :product_id
    end
  end
end
