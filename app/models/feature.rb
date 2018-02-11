# frozen_string_literal: true

##
# A Feature can be connected to {Product# Products} and {Artifact# Artifacts}
class Feature < ApplicationRecord
  belongs_to :project, touch: true
  has_and_belongs_to_many :products
  has_and_belongs_to_many :artifacts
  has_and_belongs_to_many :passages
  belongs_to :orig_feature, class_name: "Feature", optional: true
  has_many :copies, class_name: "Feature", foreign_key: "orig_feature_id"


  validates :name, presence: true

  attribute :to_remove
  attribute :to_add
  amoeba do
    enable
    exclude_association :products
    customize([
                  lambda do |original_feature, new_feature|
                    new_feature.orig_feature_id = original_feature.id
                  end
              ])
  end
end
