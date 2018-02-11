# frozen_string_literal: true

##
# An Artifact contains a media file and is used in {Feature# Features}
class Artifact < ApplicationRecord
  has_one_attached :file

  belongs_to :user, default: -> { User.none }
  has_many :passages, dependent: :destroy
  has_and_belongs_to_many :features

  validates :name, :file, presence: true

  def get_text
    Tempfile.open("textfile") do |tempfile|
      tempfile.binmode
      tempfile.write file.download
      tempfile.rewind
      henkei = Henkei.new tempfile
      henkei.text.force_encoding "iso-8859-1"
    end
  end
end
