# frozen_string_literal: true

##
# A Project contains {Product# Products} and {Feature# Features}
class Project < ApplicationRecord
  belongs_to :user
  belongs_to :orig_project, class_name: "Project", optional: true

  has_many :features, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :copies, class_name: "Project", foreign_key: "orig_project_id"

  validates :name, presence: true

  amoeba do
    enable
    prepend name: "Copy of "
    customize([
                  lambda do |original_project, new_project|
                    new_project.orig_project_id = original_project.id
                  end
              ])
  end

  def list_artifacts
    artifacts = []
    features.each do |feature|
      feature.artifacts.each do |artifact|
        unless artifacts.include? artifact
          artifacts << artifact
        end
      end
      feature.passages.each do |passage|
        unless artifacts.include? passage.artifact
          artifacts << passage.artifact
        end
      end
    end
    artifacts
  end

  def list_artifact_ids
    artifact_ids = []
    features.each do |feature|
      feature.artifacts.each do |artifact|
        unless artifact_ids.include? artifact
          artifact_ids << artifact.id
        end
      end
      feature.passages.each do |passage|
        unless artifacts.include? passage.artifact
          artifact_ids << passage.artifact.id
        end
      end
    end
    artifact_ids
  end
end
