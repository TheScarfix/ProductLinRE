class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.binary :avatar
      t.text :description
      t.boolean :is_admin

      t.timestamps
    end
  end
end
