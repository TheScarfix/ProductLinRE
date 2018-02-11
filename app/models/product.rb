# frozen_string_literal: true

##
# A Product can be connected to {Feature# Features} and be downloaded to .zip File with {download}
class Product < ApplicationRecord
  belongs_to :project, touch: true
  has_and_belongs_to_many :features
  has_many :copies, class_name: "Product",
           foreign_key:        "orig_product_id"
  belongs_to :orig_product, class_name: "Product", optional: true

  validates :name, presence: true

  ##
  # Collects all Artifact and Passage files inside a zip and presents it to the user as downloadable file
  def create_zip(tempfile)
    Zip::OutputStream.open(tempfile) do |zipfile|
      # project description
      zipfile.put_next_entry(project.name + " description.txt")
      zipfile.print project.description
      features.each do |feature|

        # feature description
        zipfile.put_next_entry(feature.name + "/description.txt")
        zipfile.print feature.description

        feature.artifacts.each do |artifact|
          zipfile.put_next_entry(feature.name + "/" + artifact.name + "/description.txt")
          zipfile.print artifact.description
          zipfile.put_next_entry(feature.name + "/" + artifact.name + "/" + artifact.file.filename.to_s)
          zipfile.print artifact.file.download
        end

        feature.passages.each do |passage|
          zipfile.put_next_entry(feature.name + "/" + passage.name + "/description.txt")
          zipfile.print passage.description
          zipfile.put_next_entry(feature.name + "/" + passage.name + "/" + passage.file.filename.to_s)
          zipfile.print passage.file.download
        end

      end
      zipfile.close
    end
  end

  amoeba do
    enable
    exclude_association :features
    customize([
                  lambda do |original_product, new_product|
                    new_product.orig_product_id = original_product.id
                  end
              ])
  end
end
