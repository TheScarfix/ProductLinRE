class RemoveFilenameFromArtifactAndAddNameAndDescriptionToPassage < ActiveRecord::Migration[5.2]
  def change
    add_column :passages, :name, :string
    add_column :passages, :description, :text
    remove_column :passages, :filename, :string
    remove_column :artifacts, :filename, :string
  end
end
