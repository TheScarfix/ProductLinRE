class AddFileToPassage < ActiveRecord::Migration[5.1]
  def change
    add_column :passages, :file, :string
  end
end
