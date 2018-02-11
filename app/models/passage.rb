# frozen_string_literal: true

##
# A Passage is a section of an {Artifact},
# for example a section of a text file
class Passage < ApplicationRecord
  has_one_attached :file

  belongs_to :artifact
  belongs_to :user
  has_and_belongs_to_many :features
  validates :name, :file, presence: true
  attribute :crop
  attribute :text
  attribute :start
  attribute :duration


  def get_text
    Tempfile.open("textfile") do |tempfile|
      tempfile.binmode
      tempfile.write file.download
      tempfile.rewind
      henkei = Henkei.new tempfile
      henkei.text.force_encoding "iso-8859-1"
    end
  end

  ##
  # processes the user input, then processes the artifact and attaches the
  # resulting file to the Passage
  # @param artifact [Artifact] the artifact to process
  # @param params [ActionController::Parameters] parameters needed for artifact
  #   processing like image crop values
  def attach_passage_file(artifact, params)
    if artifact.file.image?
      save_image_passage(artifact, params[:crop])
    elsif artifact.file.text? || artifact.file.content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ||
        artifact.file.content_type == "application/vnd.oasis.opendocument.text"
      save_text_passage(params[:text])
    else
      save_video_audio_passage(artifact, params[:start], params[:duration])
    end
  end

  private

    ##
    # attaches the image of the artifact to the passage,
    # which is cropped to the input values
    # @param artifact [Artifact] the artifact with the original Image
    # @param crop [String] the crop value in String format
    #   (width*height+start_x+start_y)
    def save_image_passage(artifact, crop)
      Tempfile.open("image_passage") do |f|
        f.binmode
        f.write(artifact.file.download)
        f.rewind
        crop_image(f.path, crop)
        file.attach(io:           f,
                    filename:     artifact.file.filename,
                    content_type: artifact.file.content_type)
      end
    end

    ##
    # crops an image
    # @param path [String] path to the image
    # @param crop [String] crop values in String format,
    #   like in {save_image_passage}
    def crop_image(path, crop)
      MiniMagick::Image.new(path) do |img|
        img.resize "1000>"
        img.crop crop
        img.write(path)
      end
    end

    ##
    # attaches a text file with the selected section as content
    # @param text [String] the selected section of the original text file
    def save_text_passage(text)
      Tempfile.open("text_passage") do |f|
        f.write(text)
        f.rewind
        file.attach(io:           f,
                    filename:     "#{name}.txt",
                    content_type: "text/plain")
      end
    end

    ##
    # creates a tempfile and loads the artifact file into it, then calls
    # {create_video_audio_passage} to cut and attach the passage
    # @param artifact [Artifact] the artifact with the original file
    # @param start [String] start value for the cut
    # @param duration [String] duration value for the cut
    def save_video_audio_passage(artifact, start, duration)
      Tempfile.open("video_audio_artifact") do |f|
        f.binmode
        f.write(artifact.file.download)
        f.rewind
        create_video_audio_passage(f.path,
                                   artifact.file.filename,
                                   start, duration)
      end
    end

    ##
    # creates a tempfile for the passage and cuts the file with ffmpeg, then
    # attaches it
    # @param path [String] artifact file path
    # @param filename [ActiveStorage::Filename] artifact file filename
    # @param start [String] start value for the cut
    # @param duration [String] start value for the cut
    def create_video_audio_passage(path, filename, start, duration)
      Tempfile.open(["video_audio_passage",
                     filename.extension_with_delimiter]) do |f|
        f.binmode
        cmd = "ffmpeg -y -i \"#{path}\" -ss #{start} -t #{duration} \"#{f.path}\""
        system(cmd)
        file.attach(io:           f,
                    filename:     filename.to_s,
                    content_type: artifact.file.content_type)
      end
    end
end
