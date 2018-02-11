# frozen_string_literal: true

module ApplicationHelper
  def avatar_url(user)
    # default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon"
    # &d=#{CGI.escape(default_url)}"
  end

  def file_name_with_icon(resource)
    if resource.file.attached?
      if resource.file.image?
        icon("file-image-o", resource.name)
      elsif resource.file.audio?
        icon("file-audio-o", resource.name)
      elsif resource.file.video?
        icon("file-video-o", resource.name)
      elsif resource.file.text?
        icon("file-text-o", resource.name)
      elsif resource.file.content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        icon("file-word-o", resource.name)
      elsif resource.file.content_type == "application/vnd.oasis.opendocument.text"
        icon("file-text-o", resource.name)
      end
    end
  end

  def check_user_permission(resource)
    resource.user == current_user || current_user.is_admin?
  end
end
