class AddUserRelationToPassage < ActiveRecord::Migration[5.2]
  def change
    add_reference :passages, :user, foreign_key: true
  end
end
